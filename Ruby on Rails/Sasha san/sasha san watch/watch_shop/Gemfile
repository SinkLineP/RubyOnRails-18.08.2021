source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
#gem 'activestorage'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'jquery-rails'


gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
gem 'jbuilder'
#gem 'oj'
#gem 'oj_mimic_json'
gem 'pq'
gem 'puma'
gem 'sassc-rails'
gem 'turbolinks'
gem 'uglifier'

#gem 'webpacker'

gem 'meta-tags'
gem 'breadcrumbs_on_rails'
gem 'turbolinks'

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'pg'
  gem 'pry'
  gem 'rails-controller-testing'
#  gem 'rb-readline'
  gem 'rspec-json_expectations'
  gem 'rspec-rails', '~> 4.0.0.beta'
  end

group :development do
  gem 'listen'
  gem 'web-console'
end

group :test do
#  gem 'capybara'
  gem 'webdrivers'
  gem 'db-query-matchers'
  gem 'json_spec'
#  gem 'launchy'
  gem 'rubocop'
  gem 'shoulda-matchers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
