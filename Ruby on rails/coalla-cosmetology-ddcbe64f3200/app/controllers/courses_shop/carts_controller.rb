module CoursesShop
  class CartsController < BaseController
    before_action :authenticate_user!

    def show
      @order = current_user.orders.new(cart: true)
      @order.group_subscription_ids = current_user.cart_subscriptions.map(&:id)
      Orders::PaymentsCalculator.new(@order).recalculate
    end

    def update
      order = Order.new(order_params)
      Orders::PaymentsCalculator.new(order).recalculate
      lock_button = order.current_group_subscriptions.count == 0
      order.user = current_user
      price_block_html = render_to_string(partial: 'courses_shop/carts/price_block', locals: { order: order })
      render json: {
        data:
          {
            priceBlock: price_block_html,
            lockButton: lock_button
          },
        mindbox: Mindbox::Operations.operation_parameters(:set_cart_item_list, order: order)
      }
    end

    private

    def order_params
      params.require(:order).permit(:promo_code_id,
                                    :cart,
                                    :full,
                                    group_subscription_ids: [])
    end
  end
end