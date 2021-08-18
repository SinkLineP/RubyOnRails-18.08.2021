module Yandex
  module API
    module Direct
      URL_API = 'https://api.direct.yandex.ru/live/v4/json/'
    end
  end
end


config_path = File.join(Rails.root, 'config', 'yandex.yml')
Yandex::API::Direct.load(config_path, Rails.env)

yandex_config = OpenStruct.new(YAML.load_file(config_path)[Rails.env])

Direct::API::V5.configure do |config|
  config.host = 'api.direct.yandex.com'
  config.auth_token = yandex_config.token
  config.client_login = yandex_config.login
  config.language = yandex_config.language
end