class Registration::RegistrationData

  def initialize(session, key)
    @session = session
    @key = key
  end

  def clear!
    @session.delete(@key)
    @session.keys.grep(/^devise\./).each { |k| session.delete(k) }
  end

  def [](attribute)
    data[attribute]
  end

  private

  def data
    @session.fetch(@key, {}).symbolize_keys
  end

end