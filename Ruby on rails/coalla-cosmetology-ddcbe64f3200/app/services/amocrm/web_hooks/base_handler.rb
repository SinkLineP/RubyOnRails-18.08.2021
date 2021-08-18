module Amocrm
  module WebHooks
    class BaseHandler
      attr_reader :resource_params

      def initialize(resource_params)
        @resource_params = resource_params
      end

      def create
        resource_params.each do |data|
          begin
            entity = reload_entity(data)
            builder_class.new(entity).create_or_update!
          rescue Amocrm::UnprocessableDataException => ex
            logger.error("Failed to process data.\n#{ex.message}.")
          rescue Exception => ex
            logger.error("Unhandled exception.\n#{ex.message}\n#{ex.backtrace.join("\n")}")
            CustomExceptionNotifier.notify_exception(ex)
          end
        end
      end

      protected

      def builder_class
        raise NotImplemented
      end

      def reload_entity(data)
        raise NotImplemented
      end

      def logger
        @logger ||= Logger.new("#{Rails.root}/log/amo_hooks.log")
      end
    end
  end
end