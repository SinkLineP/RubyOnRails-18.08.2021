require 'csv'

module Mindbox
  class OrdersCsv
    class << self
      def export
        file_path = Rails.root.join('public', 'orders.csv')
        CSV.open(file_path, 'wb', col_sep: ';') do |csv|
          csv << %w(RetailOrderWebsiteId CustomerWebSiteID CreatedDateTime LastUpdatedDateTime PaymentType ProductId Quantity ActualPriceForCustomerOfLine TotalOrderPrice Status)
          Order.in_cart.ordered.find_each(batch_size: 5000) do |order|
            order.group_subscriptions.each do |subscription|
              csv << [
                order.id,
                order.user_id,
                order.created_at.strftime('%Y-%m-%d %H:%M'),
                order.updated_at.strftime('%Y-%m-%d %H:%M'),
                order.payment_type.text,
                subscription.id,
                1,
                subscription.price,
                order.full_price - order.discount_sum,
                order.status.text
              ]
            end
          end
        end
      end
    end
  end
end