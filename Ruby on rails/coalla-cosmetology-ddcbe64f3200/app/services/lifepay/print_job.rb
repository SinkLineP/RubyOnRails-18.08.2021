module Lifepay
  class PrintJob
    include HTTParty

    format :json

    def self.config
      OpenStruct.new(Rails.application.secrets.lifepay)
    end

    delegate :post, :config, to: :class

    base_uri config.api_endpoint

    def initialize(receipt_id, params)
      @receipt_id = receipt_id
      @params = params.with_indifferent_access
    end

    def perform
      receipt = CashReceipt.find(@receipt_id)
      request_body = build_request_params.to_json
      response = post('/cloud-print/create-receipt', body: request_body)
      receipt.assign_attributes(code: response.code,
                                 response: response.body,
                                 request: request_body)
      receipt.uuid = response.body['uuid'] if response.body['code'] == 0
      receipt.save!
    end

    private

    def build_request_params
      result = {
        apikey: config.api_key,
        login: config.login.to_s,
        type: 'payment',
        mode: 'print',
        card_amount: @params[:sum].to_f,
      }
      result[:purchase] = { products: build_products_params }
      result[:client_email] = @params[:client_email] if @params[:client_email].present?
      result[:test] = 0 unless Rails.env.production?
      result
    end

    def create_cash_receipt!
      raise ::NotImplemented
    end

    def build_products_params
      return build_order_products if receipt.order
      return build_default_products(receipt.group_subscription.course_name) if receipt.group_subscription
      build_default_products(@params[:service_name])
    end

    def build_order_products
      order = receipt.order
      order.group_subscriptions.map do |subscription|
        item = {
          name: subscription.course.name,
          quantity: 1,
          tax: 'none'
        }
        item.merge(subscription_price_params(subscription, order))
      end
    end

    def build_default_products(name)
      [
        {
          name: name,
          quantity: 1,
          price: @params[:sum].to_f,
          tax: 'none'
        }
      ]
    end

    def subscription_price_params(subscription, order)
      unless subscription.group_price.one_time_payment?
        payment_log = order.payment_logs.detect { |log| log.group_id == subscription.group_id }
        return {} unless payment_log
        return { price: payment_log.amount }
      end

      return {} if subscription.price_without_discount == 0
      data = { price: subscription.price_without_discount }
      data[:discount] = discount_data(subscription) if subscription.discount
      data
    end

    def discount_data(subscription)
      if subscription.discount.percent?
        { type: 'percent', value: subscription.discount.value }
      else
        { type: 'amount', value: subscription.discount_amount }
      end
    end

    def receipt
      @receipt ||= CashReceipt.find(@receipt_id)
    end
  end
end