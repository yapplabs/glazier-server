source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'rails-api'
gem 'pg'

group :development do
  gem 'guard-rspec'
  gem 'ruby_gntp' if ENV['USE_GUARD_RUBY_GNTP']
  # gem 'debugger'
end
group :development, :test do
  gem 'rspec-rails', '~> 2.0'
end
group :test do
  gem 'webmock', '~> 1.11'
end
