UniSender::Client.class_eval do

  private

  def default_request(action, params={})
    params = translate_params(params) if defined?('translate_params')
    params.merge!(api_key: api_key, format: 'json')
    query = make_query(params)
    url = URI.parse("https://api.unisender.com/#{locale}/api/#{action}")
    JSON.parse(HTTParty.post(url, body: query, verify: false).body)
  end

end
