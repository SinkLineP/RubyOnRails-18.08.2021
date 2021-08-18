module Amocrm
  module Operations
    class CreateCallTask
      def initialize(call_result)
        @call_result = call_result
        @group_subscription = call_result.group_subscription
      end

      def perform
        return if @group_subscription.try(:amocrm_id).blank?
        lead = Amocrm::Entities::Lead.find(@group_subscription.amocrm_id)
        task = Amorail::Task.new(text: task_text,
                                 complete_till: Time.now + 4.hours,
                                 element_id: lead.id,
                                 element_type: Amocrm::ElementType::LEAD,
                                 task_type: Amorail.properties.tasks['follow_up'].id,
                                 responsible_user_id: lead.responsible_user_id)
        task.save!
        task
      end

      private

      def task_text
        return 'Дозвонились. Заказан обратный звонок' if @call_result.success?
        'Не смогли дозвониться до студента'
      end
    end
  end
end
