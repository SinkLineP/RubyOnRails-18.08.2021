module Calls
  class AmocrmNoticesTask
    class << self
      def run
        new.run
      end
    end

    def run
      handle_success_calls
      hadnle_failed_calls
    end

    private

    def handle_success_calls
      CallResult.not_processed.success.each do |call_result|
        Amocrm::Operations::CreateCallNote.new(call_result).perform
        Amocrm::Operations::CreateCallTask.new(call_result).perform if call_result.callback_requested?
        call_result.update_columns(processed: true)
      end
    end

    def hadnle_failed_calls
      ids = CallResult.not_processed.not_success.group(:group_subscription_id).having('count(*) >= ?', CallResult::MAXIMUM_CALLS).select('MAX("call_results"."id")')
      CallResult.where(id: ids).each do |call_result|
        Amocrm::Operations::CreateCallNote.new(call_result).perform
        Amocrm::Operations::CreateCallTask.new(call_result).perform
        call_result.update_columns(processed: true)
      end
    end
  end
end