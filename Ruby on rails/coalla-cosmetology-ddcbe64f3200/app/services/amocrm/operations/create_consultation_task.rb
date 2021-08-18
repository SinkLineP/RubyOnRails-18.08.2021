module Amocrm
  module Operations
    class CreateConsultationTask
      def initialize(consultation_id)
        @consultation_id = consultation_id
      end

      def perform
        return unless consultation

        contact = find_or_create_contact!
        create_task!(contact)
      end

      def failure(job)
        error = StandardError.new("Unable to create consultation task. Job #{job.id}")
        error.set_backtrace(job.last_error)
        CustomExceptionNotifier.notify_exception(error)
      end

      protected

      attr_reader :consultation_id

      def find_or_create_contact!
        contact = [consultation.email, consultation.phone].reject(&:blank?).flat_map do |field|
          Amorail::Contact.find_by_query(field)
        end.first

        unless contact
          contact = Amorail::Contact.new(name: consultation.name,
                                         phone: consultation.phone,
                                         email: consultation.email)
          contact.save!
        end

        contact
      end

      def create_task!(contact)
        #TODO: Disabled amorails rasks
        # task = Amorail::Task.new(text: "Консультация. #{consultation.name}",
        #                          complete_till: consultation.date_time,
        #                          element_id: contact.id,
        #                          element_type: Amocrm::ElementType::CONTACT,
        #                          task_type: Amorail.properties.tasks['follow_up'].id,
        #                          responsible_user_id: contact.responsible_user_id)
        # task.save!
      end

      def consultation
        @consultation ||= Consultation.find_by(id: consultation_id)
      end
    end
  end
end