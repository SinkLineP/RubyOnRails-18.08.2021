module Amo
  class LeadsController < Amo::BaseController

    def change_status
      leads_params = params[resource_name][:status].try(:values)

      if leads_params.blank?
        render json: { result: 'no data processed', errors: [] }

        return
      end

      Delayed::Job.enqueue(AmoHooksHandlersJob.new(leads_params, resource_name, :change_status))
      render json: { result: 'ok' }
    end

    protected

    def resource_name
      :leads
    end

    def handler
      Amocrm::WebHooks::LeadsHandler
    end
  end
end