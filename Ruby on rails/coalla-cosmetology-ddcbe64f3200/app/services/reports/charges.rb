module Reports
  class Charges
    attr_reader :subscriptions, :begin_on, :end_on, :sms_price

    def initialize(begin_on, end_on, sms_price = 0.5)
      @begin_on = begin_on
      @end_on = end_on
      @sms_price = sms_price.to_f
      @subscriptions = GroupSubscription.includes(:student, :course, :payments, :group, student: :campaign).joins(:student).where(sale_success_on: begin_on..end_on)
    end

    def generate
      package = Axlsx::Package.new

      query = Calculations::DataQuery.new(begin_on, end_on)
      grouped_subscriptions = subscriptions.group_by(&:group)

      # menu
      package.workbook.add_worksheet(name: 'Меню') do |sheet|
        Generators::ChargesMenuSheet.new(sheet, grouped_subscriptions.keys).generate
      end

      # ltv
      students_with_ltv = subscriptions.group_by(&:student).map do |student, subscriptions|
        subscriptions_with_charges = subscriptions.map { |subscription| Calculations::SubscriptionWithCharges.new(subscription, query, sms_price) }
        Calculations::StudentWithLtv.new(student, subscriptions_with_charges)
      end
      package.workbook.add_worksheet(name: 'LTV') do |sheet|
        Generators::LtvSheet.new(sheet, students_with_ltv).generate
      end

      # groups
      grouped_subscriptions.each do |group, subscriptions|
        subscriptions_with_charges = subscriptions.map { |subscription| Calculations::SubscriptionWithCharges.new(subscription, query, sms_price) }
        package.workbook.add_worksheet(name: group.name.gsub('/', ' ')) do |sheet|
          Generators::ChargesSheet.new(sheet, subscriptions_with_charges).generate
        end
      end

      package.use_shared_strings = true

      package
    end
  end
end