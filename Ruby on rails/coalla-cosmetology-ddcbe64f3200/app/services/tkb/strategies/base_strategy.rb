# frozen_string_literal: true

module Tkb
  module Strategies
    class BaseStrategy
      def initialize(params = {})
        @params = params.with_indifferent_access
      end

      def process!
        logger.info("Tkb info: #{@params}")

        data_loaded = load_data
        create_receipt!

        unless data_loaded
          logger.error("Couldn't load data!")
          logger.info("Payment not approved!")
          return false
        end

        apply_payment!
        logger.info("Payment approved!")
        "OK"
      end

      private

      def load_data
        raise ::NotImplemented
      end

      def create_receipt!
        receipt = CashReceipt.create!(receipt_params)
        @params[:sum] = 1
        ::Delayed::Job.enqueue(::Lifepay::PrintJob.new(receipt.id, @params)) if receipt.present?
        logger.info("Receipt(id=#{receipt.id}) created.")
      end

      def receipt_params
        raise ::NotImplemented
      end

      def correct_data?
        plain_key = "#{@params[:id]}#{@params[:sum]}#{@params[:clientid]}#{@params[:orderid]}"
        @params[:key] == md5_with_secret(plain_key)
      end

      def apply_payment!
        raise ::NotImplemented
      end

      def md5_with_secret(string)
        Digest::MD5.hexdigest("#{string}#{Rails.application.secrets.paykeeper_secret}")
      end

      def logger
        @logger ||= Logger.new("#{Rails.root}/log/tkb.log")
      end
    end
  end
end
