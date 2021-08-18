module Mindbox
  class XmlApiOperation
    include HTTParty

    def self.config
      OpenStruct.new(Rails.application.secrets.mindbox)
    end

    delegate :get, :post, :config, to: :class

    base_uri config.api_endpoint

    class << self
      def enqueue(operation_name, data = {})
        Delayed::Job.enqueue(Mindbox::XmlApiOperation.new(operation_name, data))
      end
    end

    def initialize(operation_name, data = {})
      @operation_name = operation_name
      @data = data
    end

    def perform
      url = "/v3/operations/async?endpointId=#{config.endpoint_id}&operation=#{@operation_name}"
      body = "Mindbox::Xml::#{@operation_name}".constantize.new(@data).build
      logger.info("POST #{url}\r\n#{body}")
      return unless Rails.env.production?
      headers = {
        'Content-Type' => 'application/xml',
        'Accept' => 'application/xml',
        'Authorization' => "Mindbox secretKey=\"#{config.secret_key}\""
      }
      result = post(url, headers: headers, body: body).parsed_response
      logger.info("Response:\r\n#{result}")
    end

    def failure(job)
      error = StandardError.new("Unable to call mindbox operation. Job #{job.id}")
      error.set_backtrace(job.last_error)
      ::CustomExceptionNotifier.notify_exception(error)
    end

    private

    def logger
      @logger ||= ::Logger.new("#{Rails.root}/log/mindbox.log")
    end
  end
end