module Amocrm
  module Import
    class Base
      def run
        @errors = {}

        perform_import

        @errors
      end

      protected

      def add_error(item, ex)
        @errors[item] = ex
      end

      def params
        result = {}
        last_import = AmocrmImport.last_completed
        result[:datetime] = last_import.completed_at if last_import.try(:completed_at).present?
        result
      end

      def perform_import
        #hook
      end
    end
  end
end