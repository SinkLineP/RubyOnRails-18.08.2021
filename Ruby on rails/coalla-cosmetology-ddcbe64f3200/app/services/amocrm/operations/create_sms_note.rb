module Amocrm
  module Operations
    class CreateSmsNote
      def initialize(sms_id)
        @sms_id = sms_id
      end

      def perform
        return if !(sms && sms.user.try(:amocrm_id).presence)
        amo_note = create_amo_note!
        create_db_note!(amo_note)
      end

      def failure(job)
        error = StandardError.new("Unable to create sms note. Job #{job.id}")
        error.set_backtrace(job.last_error)
        CustomExceptionNotifier.notify_exception(error)
      end

      protected

      attr_reader :sms_id

      def create_amo_note!
        amo_note = Amocrm::Entities::Note.new(element_id: sms.user.amocrm_id,
                                              element_type: Amocrm::ElementType::CONTACT,
                                              note_type: Note::SMS,
                                              date_create: sms.created_at,
                                              text: {TEXT: "CМС: #{sms.text}"}.to_json)
        amo_note.save!
        amo_note
      end

      def create_db_note!(amo_note)
        builder = Builders::Note.new(amo_note, Student)
        builder.create_or_update!
      end

      def sms
        @sms ||= Sms.find_by(id: sms_id)
      end
    end
  end
end