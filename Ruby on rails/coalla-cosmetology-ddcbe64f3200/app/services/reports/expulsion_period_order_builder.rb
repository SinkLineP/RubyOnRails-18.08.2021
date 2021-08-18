module Reports
  class ExpulsionPeriodOrderBuilder

    def self.build(options = {})
      issued_document_ids = SubscriptionDocument.ready.issued.pluck(:id)

      scope = GroupSubscription
                .preload(:student,
                         :amocrm_status,
                         :group,
                         :subscription_documents)
                .joins(:student, :amocrm_status, :course, :subscription_documents)
                .actual
                .where(subscription_documents: { id: issued_document_ids, issued_at: options[:begin_at]..options[:end_at] })
                .group_by(&:group_id)
      file_path = Documents::Generators::ExpulsionPeriodOrder.new({ items: scope,
                                                                    date: options[:date],
                                                                    number: options[:number] || 1 }).generate
      file_path
    end
  end
end