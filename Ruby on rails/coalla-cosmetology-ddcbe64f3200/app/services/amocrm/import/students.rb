module Amocrm
  module Import
    class Students < Base

      protected

      def perform_import
        ThinkingSphinx::Deltas.suspend(:user) do
          Entities::Contact.each(params) do |contact|
            begin
              Builders::Student.new(contact).create_or_update!
            rescue => ex
              add_error(contact, ex)
            end
          end
        end
      end
    end
  end
end