module Smsc
  class Client
    include HTTParty

    mattr_accessor :settings
    self.settings = OpenStruct.new(Rails.application.secrets.smsc)

    base_uri settings.base_url

    delegate :get, :post, to: :class

    def send_message(to, text)
      send_post_request('/send.php',
                        phones: to,
                        mes: text,
                        sender: 'InstitutDRK')
    end

    def get_message_status(phone, id)
      send_post_request('/status.php', phone: phone, id: id)
    end

    private

    def send_post_request(method, body = {})
      if Rails.env.development?
        ap build_body(body)
        return {}
      end
      result = post(method, body: build_body(body))
      JSON.parse(result.body)
    rescue JSON::ParserError => ex
      Rails.logger.error("Failed to send request to sms gateway. #{ex.message}")
      {}
    rescue => ex
      Rails.logger.error("Failed to send request to sms gateway. #{ex.message}")
      CustomExceptionNotifier.notify_exception(ex)
      {}
    end

    def build_body(options={})
      options.deep_merge!({
                            login: settings.login,
                            psw: Digest::MD5.hexdigest(settings.password),
                            charset: 'utf-8',
                            fmt: 3
                          })
    end
  end
end