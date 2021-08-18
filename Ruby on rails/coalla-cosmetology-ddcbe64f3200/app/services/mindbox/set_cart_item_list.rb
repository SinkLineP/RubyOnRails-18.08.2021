module Mindbox
  class SetCartItemList < Operation
    def data
      order = @options[:order]
      return unless order.try(:cart?)
      {
        customer: customer_info(order.user),
        productList: order.order_group_subscriptions.map do |subscription|
          product_list(subscription)
        end
      }
    end

    private

    def customer_info(user)
      {
        ids: {
          userwebsiteid: user.id
        },
        email: user.email,
        mobilePhone: user.phone,
      }
    end

    def product_list(order_group_subscription)
      group_subscription = order_group_subscription.group_subscription
      course = group_subscription.course
      group_price = group_subscription.group_price
      {
        product: {
          ids: {
            website: course.id
          }
        },
        count: 1,
        price: group_price.cost
      }
    end
  end
end