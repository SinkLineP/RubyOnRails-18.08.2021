module Amocrm
  module Import
    class Notes < Base

      protected

      def perform_import
        { contact: Student, lead: GroupSubscription }.each do |type, notable_class|
          Entities::Note.each(params.merge(type: type)) do |note|
            begin
              Builders::Note.new(note, notable_class).create_or_update!
            rescue => ex
              add_error(note, ex)
            end
          end
        end
      end
    end
  end
end