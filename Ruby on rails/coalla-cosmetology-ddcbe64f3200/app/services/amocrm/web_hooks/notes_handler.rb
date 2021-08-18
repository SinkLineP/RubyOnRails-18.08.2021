module Amocrm
  module WebHooks
    class NotesHandler < BaseHandler

      def create
        resource_params.each do |data|
          note = data[:note]

          if note.blank?
            logger.error("Couldn't find note.")
            next
          end

          element_id = note[:element_id]
          group_subscription = GroupSubscription.find_by(amocrm_id: element_id)

          if group_subscription.blank?
            logger.error("Couldn't find group subscription. #{element_id}")
            next
          end
          note_text = note[:text]
          group_subscription.update_attribute(:promotion_source, Amocrm::Utils::NoteParser.parse(note_text, 'откуда')) if note_text.present?
        end
      end
    end
  end
end