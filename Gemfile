source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'rails-api', '~> 0.1.0'
gem 'pg', '~> 0.15.1'
gem 'active_model_serializers', '~> 0.8.1'
gem 'faraday', '~> 0.8.7'
gem 'faraday-http-cache', '~> 0.2.0'
gem 'rack-canonical-host'

group :development do
  gem 'guard-rspec'
  gem 'ruby_gntp' if ENV['USE_GUARD_RUBY_GNTP']
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
#  gem 'pry'
#  gem 'pry-debugger'
end

group :test do
  gem 'webmock', '~> 1.11'
  gem 'factory_girl', '~> 4.0'
  gem 'factory_girl_rails', '~> 4.0'
end
