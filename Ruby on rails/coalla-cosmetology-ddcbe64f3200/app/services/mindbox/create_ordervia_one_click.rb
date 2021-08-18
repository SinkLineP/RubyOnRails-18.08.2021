module Mindbox
  class CreateOrderviaOneClick
    def initialize(options)
      @order = options[:order]
    end

    def to_js
      return unless @order.try(:cart?)
      ['identify', {
        operation: 'CreateOrderviaOneClick',
        data: data,
        identificator: identificator
      }]
    end

    private

    def data
      {
        order: {
          webSiteId: @order.id,
          price: @order.full_price_with_discount,
          items: @order.order_group_subscriptions.map do |subscription|
            product_list(subscription)
          end
        }
      }
    end

    def identificator
      {
        provider: 'userwebsiteid',
        identity: @order.user_id
      }
    end

    def product_list(order_group_subscription)
      group_subscription = order_group_subscription.group_subscription
      course = group_subscription.course
      group_price = group_subscription.group_price
      {
        productId: course.id,
        quantity: 1,
        price: group_price.cost
      }
    end
  end
end