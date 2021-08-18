module Mindbox
  class AuthenticationToken
    class << self
      def generate(field_name, field_value)
        secret_key = Rails.application.secrets.mindbox['secret_key']
        date_time_string = Time.current.strftime('%Y-%m-%d %H:%M:%S')
        message = "ExternalIdentityAuthentication|#{field_name}|#{field_value}|#{date_time_string}"
        hash = OpenSSL::HMAC.hexdigest('SHA512', secret_key, message)
        "#{message.unpack('H*').first}|#{hash}"
      end
    end
  end
end