module Amocrm
  module Import
    class GroupSubscriptions < Base
      protected

      def perform_import
        Entities::Lead.each(params) do |lead|
          begin
            Builders::GroupSubscription.new(lead).create_or_update!
          rescue => ex
            add_error(lead, ex)
          end
        end
      end

    end
  end
end