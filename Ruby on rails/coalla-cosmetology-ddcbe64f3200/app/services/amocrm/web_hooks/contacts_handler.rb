module Amocrm
  module WebHooks
    class ContactsHandler < BaseHandler

      def delete
        ids = resource_params.map { |data| data['id'] }
        Student.where(amocrm_id: ids).update_all(deleted_at: Time.now)
      end

      protected

      def builder_class
        Amocrm::Builders::Student
      end

      def reload_entity(data)
        Amocrm::Entities::Contact.new.reload_model(data)
      end
    end
  end
end
