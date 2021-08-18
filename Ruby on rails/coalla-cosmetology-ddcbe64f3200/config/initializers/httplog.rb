require 'httplog'
HttpLog.configure do |config|
  config.logger = Logger.new("#{Rails.root}/log/http_requests.log")
  config.log_connect   = false
  config.log_benchmark = false
end