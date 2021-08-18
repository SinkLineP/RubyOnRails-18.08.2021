module Registration
  class SocialDataProcessor
    attr_reader :provider

    def initialize(provider, options = {})
      @provider = provider

      @name = options.fetch(:name, ->(omniauth) { [omniauth.info.first_name, omniauth.info.last_name] })
      @url = options.fetch(:url, ->(omniauth) { omniauth.info.urls.try(:[], @provider.to_s.capitalize) })
    end

    def process(omniauth, omniauth_params)
      first_name, last_name = @name.call(omniauth)
      url = @url.call(omniauth)

      {
        uid: omniauth.uid,
        provider: omniauth.provider,
        email: omniauth.info.email,
        first_name: first_name,
        last_name: last_name,
        born_date: get_born_date(omniauth),
        access_token: omniauth.credentials.token,
        access_token_secret: omniauth.credentials.secret,
        url: url || '',
        type: omniauth_params['type'],
        aes_crypto_token: omniauth_params['token']
      }
    end

    def get_born_date(omniauth)
      case provider
        when 'facebook'
        then
          omniauth.extra.raw_info.try(:birthday)
        when 'vkontakte'
        then
          omniauth.extra.raw_info.try(:bdate)
        when 'odnoklassniki'
        then
          omniauth.extra.raw_info.try(:birthday)
        else
          nil
      end
    end
  end
end