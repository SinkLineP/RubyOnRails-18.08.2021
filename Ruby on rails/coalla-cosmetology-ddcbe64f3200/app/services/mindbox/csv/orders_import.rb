module Mindbox
  module Csv
    class OrdersImport
      include ApplicationHelper

      def initialize(options = {})
        @all = options.fetch(:all, false)
        if @all
          scope = GroupSubscription.preload(:course).actual
        else
          scope = GroupSubscription.preload(:course).actual.not_expelled.not_academic_vacation.where('DATE(group_subscriptions.sale_success_on) = ?', Date.yesterday)
        end
        @subscriptions = scope.preload(:student)
      end

      def url
        '/v2/import?operation=DirectCrm.Orders.ImportInCurrentStatus&brand=Cosmeticru&csvCodePage=65001&csvColumnDelimiter=%2C&SourceActionTemplate=LoadingOrder&externalSystem=website'
      end

      def body
        CSV.generate do |csv|
          csv << %w(Customeruserwebsiteid PointOfContact LastUpdatedDateTime ProductId Quantity ActualPriceForCustomerOfLine Status RetailOrderwebsiteId)
          @subscriptions.each { |subscription| csv << user_info(subscription) }
        end
      end

      private

      def user_info(subscription)
        [
          subscription.student_id,
          183,
          format_date_time_full(subscription.updated_at),
          subscription.course.id,
          1,
          subscription.price,
          'create',
          subscription.id
        ]
      end

    end
  end
end