module Amo
  class BaseController < ApplicationController
    skip_before_filter :verify_authenticity_token

    before_action do
      logger.info(request.fullpath)
      logger.info(params)
    end

    respond_to :json

    def create
      @start = Time.now
      if resource_params.blank?
        render json: { result: 'no data processed', errors: [] }
        write_processing_time

        return
      end

      Delayed::Job.enqueue(AmoHooksHandlersJob.new(resource_params, resource_name, :create))
      render json: { result: 'ok' }
      write_processing_time
    end

    protected

    def write_processing_time
      logger.info("Request processing time: #{Time.now - @start}")
    end

    def resource_params
      return [] if params[resource_name].blank?

      (params[resource_name][:add].try(:values) || []) + (params[resource_name][:update].try(:values) || [])
    end

    def resource_name
      raise NotImplemented
    end

    def handler
      raise NotImplemented
    end

    def logger
      @logger ||= Logger.new("#{Rails.root}/log/amo_hooks.log")
    end
  end
end