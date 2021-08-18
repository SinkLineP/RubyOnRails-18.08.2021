module Callbacks
  class DataProcessor
    attr_reader :params

    class << self
      def enqueue(params)
        Delayed::Job.enqueue(Callbacks::DataProcessor.new(params))
      end
    end

    def initialize(params)
      @params = params
    end

    def perform
      send_data
    end

    def send_data
      Rails.logger.info("POST #{url} #{params}")
      return true if Rails.env.development?
      HTTParty.post(url, body: params)
      true
    rescue ::Net::ReadTimeout => ex
      Rails.logger.error("Unable to send data. #{ex.message}")
      false
    rescue => ex
      Rails.logger.error("Unable to send data. #{ex.message}")
      CustomExceptionNotifier.notify_exception(ex)
      false
    end

    private

    def url
      @url ||= begin
        shop = Shop.find(params[:shop_id])
        Rails.application.secrets.amocore_callbak_url[shop.code.to_s]
      end
    end
  end
end