# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Encoding.default_external = Encoding::UTF_8

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end
