module AmoHelpers
  def response_json
    JSON.parse(response.body)
  end

  def read_json(file_path)
    JSON.parse(File.read(file_path))
  end

  def mock_api
    authorize_stub
    account_info_stub
    create_lead_stub
    create_task_stub
    update_contact_stub
  end

  def authorize_stub
    cookie = 'PHPSESSID=58vorte6dd4t7h6mtuig9l0p50; path=/; domain=amocrm.ru'
    stub_request(:post, full_amo_url('/private/api/auth.php?type=json'))
      .with(
        body: "{\"USER_LOGIN\":\"#{Amorail.config.usermail}\",\"USER_HASH\":\"#{Amorail.config.api_key}\"}"
      )
      .to_return(
        status: 200,
        body: '',
        headers: {
          'Set-Cookie' => cookie
        })
  end

  def account_info_stub(properties = 'info.json')
    stub_request(:get, full_amo_url("/private/api/v2/json/accounts/current?#{amo_authorization_string}"))
      .to_return(
        body: File.read("./spec/fixtures/accounts/#{properties}"),
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end

  def leads_links_stub(ids, success = true)
    url = full_amo_url("/private/api/v2/json/contacts/links?#{amo_authorization_string}&#{ids.to_query('deals_link')}")
    if success
      stub_request(:get, url)
        .to_return(
          body: File.read('./spec/fixtures/leads/links.json'),
          headers: { 'Content-Type' => 'application/json' },
          status: 200
        )
    else
      stub_request(:get, url)
        .to_return(status: 204)
    end
  end

  def create_lead_stub
    stub_request(:post, full_amo_url('/private/api/v2/json/leads/set')).to_return(
      body: File.read('./spec/fixtures/leads/create.json'),
      headers: { 'Content-Type' => 'application/json' },
      status: 200
    )
  end

  def create_task_stub
    stub_request(:post, full_amo_url('/private/api/v2/json/tasks/set')).to_return(
      body: File.read('./spec/fixtures/tasks/create.json'),
      headers: { 'Content-Type' => 'application/json' },
      status: 200
    )
  end

  def update_contact_stub
    stub_request(:post, full_amo_url('/private/api/v2/json/contacts/set')).to_return(
      body: File.read('./spec/fixtures/contacts/update.json'),
      headers: { 'Content-Type' => 'application/json' },
      status: 200
    )
  end

  def find_contacts_stub(ids, success = true)
    url = full_amo_url("/private/api/v2/json/contacts/list?#{amo_authorization_string}&#{ids.to_query('id')}")
    if success
      stub_request(:get, url)
        .to_return(
          body: File.read('./spec/fixtures/contacts/find.json'),
          headers: { 'Content-Type' => 'application/json' },
          status: 200
        )
    else
      stub_request(:get, url)
        .to_return(status: 204)
    end
  end

  def find_contact_stub(id, success = true)
    url = full_amo_url("/private/api/v2/json/contacts/list?#{amo_authorization_string}&id=#{id}")
    if success
      stub_request(:get, url)
        .to_return(
          body: File.read('./spec/fixtures/contacts/find.json'),
          headers: { 'Content-Type' => 'application/json' },
          status: 200
        )
    else
      stub_request(:get, url)
        .to_return(status: 204)
    end
  end

  def find_lead_stub(id, success = true, body = File.read('./spec/fixtures/leads/find.json'))
    url = full_amo_url("/private/api/v2/json/leads/list?#{amo_authorization_string}&id=#{id}")
    if success
      stub_request(:get, url)
        .to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
          status: 200
        )
    else
      stub_request(:get, url)
        .to_return(status: 204)
    end
  end

  def full_amo_url(part)
    URI.join(Amorail.config.api_endpoint, part)
  end

  def amo_authorization_string
    { USER_HASH: Amorail.config.api_key, USER_LOGIN: Amorail.config.usermail }.to_query
  end
end