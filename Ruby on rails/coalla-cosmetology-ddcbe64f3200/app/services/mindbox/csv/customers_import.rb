module Mindbox
  module Csv
    class CustomersImport
      include ApplicationHelper

      def initialize(options = {})
        @all = options.fetch(:all, false)
        scope = GroupSubscription.actual.not_expelled.not_academic_vacation
        if @all
          scope = scope.where('group_subscriptions.end_on > ?', Date.current)
        else
          scope = scope.where("(group_subscriptions.end_on > :today AND date(group_subscriptions.sale_success_on AT TIME ZONE '#{Time.zone.formatted_offset}') = :yesterday) OR (end_on = :yesterday)", today: Date.current, yesterday: Date.yesterday)
        end
        @subscriptions = scope.preload(:student)
      end

      def url
        '/v2/customers/import?operation=DirectCrm.Customers.Import&brand=Cosmeticru&csvCodePage=65001&csvColumnDelimiter=%2C&SourceActionTemplate=LoadingCustomer'
      end

      def body
        CSV.generate do |csv|
          csv << %w(ExternalIdentityuserwebsiteid FirstName LastName MiddleName MobilePhone Email BirthDate SourceDateTime IsSubscribedByEmail CompletedCourse SourcePointOfContact)
          @subscriptions.each { |subscription| csv << user_info(subscription) }
        end
      end

      private

      def user_info(subscription)
        user = subscription.student
        [
          user.id,
          user.first_name,
          user.last_name,
          user.middle_name,
          user.phone,
          user.email,
          feed_date_format(user.birthday),
          format_date_time_full(user.created_at),
          user.subscribed_on_blog,
          @all ? false : subscription.end_on == Date.yesterday,
          'Backend'
        ]
      end

    end
  end
end