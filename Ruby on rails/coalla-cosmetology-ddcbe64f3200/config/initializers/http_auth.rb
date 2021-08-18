module Coalla
  module HttpAuth
    extend ActiveSupport::Concern

    included do
      before_action :basic_authenticate

      def basic_authenticate
        return if %w(paykeepers call_results).include?(controller_name)
        # TODO(DL): return after google speed up
        # if ::Rails.env.staging?
        #   authenticate_or_request_with_http_basic do |username, password|
        #     username == 'demo' && password == 'agmed125r'
        #   end
        # end
      end
    end

  end
end

ApplicationController.send(:include, Coalla::HttpAuth)