class UnisenderService

  def initialize(email, context)
    @email = email
    @context = context
    @settings = OpenStruct.new(Rails.application.secrets.unisender)
    @client = UniSender::Client.new(@settings.api_key)
  end

  def subscribe!
    time = Time.current.strftime('%Y-%m-%d')
    ip = @context.request.env['HTTP_X_REAL_IP']
    list_id = @settings.lists[@context.current_shop.code.to_s]
    params = {
      list_ids: list_id,
      fields: { email: @email },
      confirm_ip: ip,
      request_ip: ip,
      confirm_time: time,
      request_time: time,
      double_optin: 1
    }
    Rails.logger.info("Unisender params: #{params}")
    if Rails.env.production? || Rails.env.staging?
      result = @client.subscribe(params)
    else
      result = 'OK'
    end
    UnisenderResult.create(email: @email, result: result)
    result
  end

end