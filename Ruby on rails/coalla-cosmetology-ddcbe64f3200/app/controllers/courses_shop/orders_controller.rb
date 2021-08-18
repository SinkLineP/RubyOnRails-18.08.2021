# frozen_string_literal: true

module CoursesShop
  class OrdersController < BaseController
    # TODO (vl): remove helpers after refactoring
    include ApplicationHelper
    include CartsHelper
    include GroupsHelper
    include HTTParty

    before_action :authenticate_user!

    layout false, except: [:pay, :pay_tkb]

    def new
      @order = current_user.orders.new(order_params)
      @order.payment_type = :bank
      Orders::PaymentsCalculator.new(@order).recalculate if @order.cart?
      render json: { popup: render_to_string("new"), fbEvent: ("fbInitiateCheckout" if current_shop.barbershop?) }
    end

    def create
      @order = create_order!
      if @order.zero_price?
        CosmetologyMailer.notify_about_new_courses(@order.user, @order.first_subscription).deliver! if @order.not_zero_subscriptions.any?
        render json: { location: courses_shop_profile_courses_path }
        return
      end


      if @order.bank?
        location = pay_courses_shop_order_path(@order)
      elsif @order.bank_tkb?
        location = pay_tkb_courses_shop_order_path(@order)
      else
        location = courses_shop_profile_courses_path(download_document_id: @order.payment_receipt.try(:id))
      end

      if @order.cart? && !@order.bank?
        render json: {
            popup: {
                title: popup_title_text(@order),
                text: popup_description_text(@order),
                name: "#popup-basket-after-payment-overview",
                link: location
            },
            dataLayer: init_data_layer,
            fbEvent: ("fbPurchase" if current_shop.barbershop?)
        }
      else
        render json: { location: location, fbEvent: ("fbPurchase" if current_shop.barbershop?) }
      end
    end

    def pay
      @order = current_user.orders.find(params[:id])
    end

    def pay_tkb
      tkb_api = OpenStruct.new(Rails.application.secrets.tkb_api)
      @order = current_user.orders.find(params[:id])
      endpoint = "api/tcbpay/gate/registerorderfromunregisteredcard"

      url = tkb_api.url + endpoint
      # TODO: return real price
      # @order.full_price_with_discount.to_i * 100,
      options = {
        "OrderID" => @order.id,
        "Amount" => 100,
        "ClientInfo" => {
          "PhoneNumber" => @order.user.phone ? @order.user.phone.to_s : "",
          "FIO" => @order.user.full_name,
          "Email" => @order.user.email ? @order.user.email : "",
        },
        "ReturnUrl" => tkb_result_courses_shop_order_url(@order),
      }
      headers = {
        "Content-Type" => "application/json",
        "TCB-Header-Login" => tkb_api.login,
        "TCB-Header-Sign" => sign_hash(JSON.generate(options), tkb_api.api_key)
      }
      response = HTTParty.post(
        url,
        headers: headers,
        body: options.to_json,
        verify: false
      )
      if response.parsed_response["errorInfo"]["errorCode"] == 0
        redirect_to response.parsed_response["formURL"]
      else
        redirect_to courses_shop_profile_courses_path
      end
    end

    def tkb_result
      params[:orderid] = params[:id]
        handler = Tkb::Handler.new(params)
        result = handler.process_payment!

        if result
          logger.info("Payment approved!")
          redirect_to courses_shop_profile_courses_path
        else
          logger.info("Payment not approved!")
          redirect_to courses_shop_profile_courses_path
        end
      end

    private

    def create_order!
      order = current_user.orders.new(order_params)
      order.transaction do
        Orders::PaymentsCalculator.new(order).recalculate if order.cart?
        order.save!
        order.group_subscriptions.each { |s| s.save! }
        if order.zero_price?
          ids = order.cart? ? order.group_subscriptions.select(&:zero_price_with_installment?).map(&:id) : []
          order.group_subscriptions.where.not(id: ids).update_all(amocrm_status_id: AmocrmStatus.success.id)
          order.update_column(:status, Order.status.paid)
        else
          order.group_subscriptions.update_all(pending_payment_at: Time.current) if order.bank?
          order.generate_payment_receipt! if order.receipt?
        end
      end
      if order.group_subscriptions.count > 1
        order.generate_documents!
      else
        order.group_subscriptions.first.save_and_generate_documents!
      end
      CoursesShopMailer.payment_message(order).deliver!
      order
    end

    def init_data_layer
      courses = @order.group_subscriptions.map do |subscription|
        {
          sku: subscription.course.id,
          name: subscription.course.name,
          category: subscription.course.specialities.first.try(:title),
          price: subscription.price_with_discount,
          quantity: 1
        }
      end
      total_transaction = @order.group_subscriptions.to_a.sum(&:price_with_discount)

      {
        event: "productClick",
        transactionId: @order.id,
        transactionTotal: total_transaction,
        transactionProducts: courses
      }
    end

    def sign_hash(data, secret)
      hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha1"), secret.encode("ASCII"), data)
      Base64.encode64(hmac).chomp
    end

    def order_params
      params.require(:order).permit(:promo_code_id,
                                    :cart,
                                    :full,
                                    :payment_type,
                                    group_subscription_ids: [])
    end
  end
end
