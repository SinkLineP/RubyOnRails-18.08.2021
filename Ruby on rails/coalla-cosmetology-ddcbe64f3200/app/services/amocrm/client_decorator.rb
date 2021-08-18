module Amocrm
  module ClientDecorator
    extend ActiveSupport::Concern

    included do
      alias_method :safe_request_without_lock, :safe_request

      # with lock
      def safe_request(method, url, params = {})
        timeout = nil
        ::AmoRequest.transaction do
          ::AmoRequest.lock_table
          timeout = ::AmoRequest.timeout
          ::AmoRequest.create!(method: method,
                               url: url,
                               params: params.to_json,
                               timeout: Time.current + timeout)
        end
        sleep(timeout)
        authorized_request(method, url, params)
      end

      def authorized_request(method, url, params = {})
        3.times do |i|
          begin
            params = params.merge(USER_LOGIN: usermail, USER_HASH: api_key)
            return send(method, url, params)
          rescue ::Amorail::AmoUnauthorizedError
            raise if i >= 2
            sleep(AmoRequest.timeout)
            authorize
          end
        end
      end

      def get(url, params = {})
        response = connect.get(url, params) do |request|
          request.headers['Cookie'] = cookies if cookies.present?
          request.headers['IF-MODIFIED-SINCE'] = params['if-modified-since'] if params['if-modified-since'].present?
        end
        handle_response(response)
      end

      def post(url, params = {})
        response = connect.post(url) do |request|
          request.headers['Cookie'] = cookies if cookies.present?
          request.headers['Content-Type'] = 'application/json'
          request.headers['IF-MODIFIED-SINCE'] = params['if-modified-since'] if params['if-modified-since'].present?
          request.body = params.to_json
        end
        handle_response(response)
      end

      def handle_response(response)
        return response if response.status == 200 || response.status == 204

        case response.status
          when 301
            fail ::Amorail::AmoMovedPermanentlyError
          when 400
            fail ::Amorail::AmoBadRequestError
          when 401
            fail ::Amorail::AmoUnauthorizedError
          when 403
            fail ::Amorail::AmoForbiddenError
          when 404
            fail ::Amorail::AmoNotFoundError
          when 500
            fail ::Amorail::AmoInternalError
          when 502
            fail ::Amorail::AmoBadGatewayError
          when 503
            fail ::Amorail::AmoServiceUnaviableError
          else
            fail ::Amorail::AmoUnknownError, response.body
        end
      end
    end
  end
end