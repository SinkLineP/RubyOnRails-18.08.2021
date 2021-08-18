module Reports
  class AdditionPeriodOrderBuilder

    def self.build(options = {})
      scope = GroupSubscription
                .preload(:student,
                         :amocrm_status,
                         :group)
                .joins(:student, :amocrm_status, :course)
                .actual
                .where(sale_success_on: options[:begin_at]..options[:end_at])
                .group_by(&:group_id)
      file_path = Documents::Generators::AdditionPeriodOrder.new({items: scope,
                                                                  date: options[:date],
                                                                  number: options[:number] || 1}).generate
      file_path
    end
  end
end