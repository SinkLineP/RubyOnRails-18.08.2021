module CoMagick
  class Client
    include HTTParty

    def self.config
      OpenStruct.new(Rails.application.secrets.co_magick)
    end

    delegate :get, :post, :config, to: :class

    base_uri config.api_endpoint

    def login
      responce = post('/login/', query: {login: config.login, password: config.password})
      responce['data']['session_key']
    end

    def sites
      safe_get('/v1/site/')
    end

    def campaigns
      safe_get('/v1/ac/')
    end

    def campaign(id)
      res = safe_get('/v1/ac_condition/', query: {id: id})
      res.first.tap do |obj|
        obj['ac_conditions'] = ActiveSupport::JSON.decode(obj['ac_conditions']) if obj['ac_conditions']
        obj['site_blocks'] = ActiveSupport::JSON.decode(obj['site_blocks']) if obj['site_blocks']
      end
    end

    def stats(site_id, campaign_id, from = Time.current, till = from)
      safe_get('/v1/stat/', query: {site_id: site_id,
                                    ac_id: campaign_id,
                                    date_from: from.beginning_of_day.strftime('%Y-%m-%d %H:%M:%S'),
                                    date_till: till.end_of_day.strftime('%Y-%m-%d %H:%M:%S')}).first
    end

    private

    def safe_get(path, options = {}, &block)
      session_key = login
      options.deep_merge!(query: {session_key: session_key})
      responce = get(path, options, &block)

      if responce['data'].present?
        ActiveSupport::JSON.decode(responce.body)['data']
      else
        nil
      end
    end
  end
end