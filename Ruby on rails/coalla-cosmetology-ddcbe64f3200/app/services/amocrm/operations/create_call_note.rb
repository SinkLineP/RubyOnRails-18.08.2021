module Amocrm
  module Operations
    class CreateCallNote
      def initialize(call_result)
        @call_result = call_result
        @group_subscription = call_result.group_subscription
      end

      def perform
        return if @group_subscription.try(:amocrm_id).blank?
        amo_note = Amocrm::Entities::Note.new(element_id: @group_subscription.amocrm_id,
                                              element_type: Amocrm::ElementType::LEAD,
                                              note_type: Note::COMMENT,
                                              date_create: @call_result.created_at,
                                              text: note_text)
        amo_note.save!
        amo_note
      end

      private

      def note_text
        return 'Не удалось дозвониться до студента.' unless @call_result.success?
        return 'Дозвонились. Заказан обратный звонок.' if @call_result.callback_requested?
        'Дозвонились, пользователь прослушал сообщение'
      end
    end
  end
end
