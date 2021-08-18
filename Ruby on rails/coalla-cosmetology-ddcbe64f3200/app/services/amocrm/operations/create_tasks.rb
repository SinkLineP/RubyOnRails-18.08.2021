module Amocrm
  module Operations
    class CreateTasks
      def initialize(responsible_user_id = 406546, contact_id = nil, lead_id = nil, name = nil, email = nil, phone = nil, text = nil)
        @contact = contact_id.present? ? Amorail::Contact.find(contact_id) : nil
        @lead = lead_id.present? ? Amorail::Lead.find(lead_id) : nil
        @name = name
        @phone = phone
        @email = email
        @responsible_user_id = responsible_user_id
        @type = Amocrm::ElementType::CONTACT
        @element_id = nil
        @text = text
      end

      def perform
        if @lead.present?
          @type = Amocrm::ElementType::LEAD
          @element_id = @lead.id
        else
          @contact ||= Amorail::Contact.find_by_query(@email) if @email.present?
          @contact ||= Amorail::Contact.find_by_query(@phone) if @phone.present?

          unless @contact.present?
            @contact = Amorail::Contact.new(name: @name, phone: @phone, email: @email)
            @contact.save!
          end
          @element_id = @contact.id
        end
        create_task!(@element_id, @text, @type)
      end

      private
        def create_task!(id, text, type)
          task = Amorail::Task.new(text: text,
                                   complete_till: Time.now + 4.hours,
                                   element_id: id,
                                   element_type: type,
                                   task_type: Amorail.properties.tasks['follow_up'].id,
                                   responsible_user_id: @responsible_user_id)
          task.save!
        end
    end
  end
end