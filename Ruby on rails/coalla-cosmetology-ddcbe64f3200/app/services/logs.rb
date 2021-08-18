module Logs
  def included(base)
    base.class_eval do
      attr_writer :logger
    end
  end

  protected

  def log_message(msg)
    @logger.info(msg)
    p msg if Rails.env.development?
  end

  def log_error(msg, exception = nil)
    message = msg.dup

    if exception.present?
      message << "\n#{exception.class} (#{exception.message}):\n"
      message << "\s\s" << exception.backtrace.join("\n\s\s")
    end

    @logger.error("#{message}\n\n")
    p msg if Rails.env.development?
  end
end