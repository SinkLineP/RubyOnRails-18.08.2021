module Calls
  class Voximplant
    include HTTParty

    def self.config
      OpenStruct.new(Rails.application.secrets.voximplant)
    end

    delegate :get, :post, :config, to: :class

    base_uri config.api_endpoint

    def create_call_list(csv)
      headers = {
        'Content-Type' => 'text/csv'
      }
      query = {
        account_id: config.account_id,
        api_key: config.api_key,
        application_id: config.application_id,
        rule_id: config.rule_id,
        priority: 1,
        max_simultaneous: 2,
        num_attempts: 1,
        name: 'callList'
      }.to_query
      post("/CreateCallList?#{query}",
           headers: headers,
           body: csv)
    end
  end
end