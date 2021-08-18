module Mindbox
  class CsvApiOperation
    include HTTParty

    def self.config
      OpenStruct.new(Rails.application.secrets.mindbox)
    end

    delegate :get, :post, :config, to: :class

    base_uri config.csv_api_endpoint

    class << self
      def perform(operation_name, data = {})
        new(operation_name, data).perform
      end
    end

    def initialize(operation_name, data = {})
      @operation_name = operation_name
      @data = data
    end

    def perform
      operation = "Mindbox::Csv::#{@operation_name}".constantize.new(@data)
      url = operation.url
      body = operation.body
      logger.info("POST #{url}\r\n#{body}")
      return unless Rails.env.production?
      headers = {
        'Authorization' => "Basic #{config.csv_api_key}",
        'Accept' => 'application/xml',
        'Content-Type' => 'text/csv'
      }
      response = post(url, headers: headers, body: body).parsed_response
      logger.info("Response:\r\n#{response}")
    end

    def logger
      @logger ||= ::Logger.new("#{Rails.root}/log/mindbox.log")
    end
  end
end