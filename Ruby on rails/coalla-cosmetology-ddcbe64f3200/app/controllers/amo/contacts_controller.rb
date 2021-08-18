module Amo
  class ContactsController < Amo::BaseController

    def delete
      if destroy_params.blank?
        render json: { result: 'no data processed' }

        return
      end

      Delayed::Job.enqueue(AmoHooksHandlersJob.new(destroy_params, resource_name, :delete))
      render json: { result: 'ok' }
    end

    protected

    def resource_name
      :contacts
    end

    def handler
      Amocrm::WebHooks::ContactsHandler
    end

    def destroy_params
      return [] if params[resource_name].blank?

      (params[resource_name][:delete].try(:values) || [])
    end
  end
end