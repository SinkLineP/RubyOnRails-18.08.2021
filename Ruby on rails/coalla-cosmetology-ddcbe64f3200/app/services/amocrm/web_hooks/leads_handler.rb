module Amocrm
  module WebHooks
    class LeadsHandler < BaseHandler

      def change_status
        resource_params.each do |data|
          begin
            lead = reload_entity(data)
            Amocrm::Notifications::StatusChanged.new(lead).notify if lead.status_id.to_i == ::AmocrmStatus::SUCCESS && ::AmocrmPipeline.resuscitation.exclude?(lead.pipeline_id.to_i)
          rescue Exception => ex
            logger.error("Unhandled exception.\n#{ex.message}\n#{ex.backtrace.join("\n")}")
            CustomExceptionNotifier.notify_exception(ex)
          end
        end
      end

      protected

      def builder_class
        Amocrm::Builders::GroupSubscription
      end

      def reload_entity(data)
        Amocrm::Entities::Lead.new.reload_model(data)
      end
    end
  end
end