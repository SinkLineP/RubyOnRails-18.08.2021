# frozen_string_literal: true

module Tkb
  class Handler
    def initialize(params = {})
      @params = params.with_indifferent_access
      @payment_type = load_payment_type
    end

    def process_payment!
      tkb_strategy = "Tkb::Strategies::#{@payment_type}Strategy".constantize.new(@params)
      tkb_strategy.process!
    end

    private

    def load_payment_type
      if @params[:orderid].present?
        return "Site" if Order.where(id: @params[:orderid]).exists?
        return "Amocrm" if GroupSubscription.where(amocrm_id: @params[:orderid]).exists?
      end
      "Service"
    end
  end
end
