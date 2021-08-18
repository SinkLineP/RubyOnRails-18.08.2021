require 'capybara/rspec'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
WebMock::Config.instance.query_values_notation = :flat_array

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.around(:each, :run_delayed_jobs) do |example|
    Delayed::Worker.delay_jobs = false

    example.run

    Delayed::Worker.delay_jobs = true
  end
end
