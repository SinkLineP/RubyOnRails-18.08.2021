class CustomExceptionNotifier
  class << self
    def notify_exception(ex)
      if Rails.env.development? || Rails.env.test?
        raise ex
      else
        ExceptionNotifier.notify_exception(ex)
      end
    end
  end
end