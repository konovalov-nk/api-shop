source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.5'

gem 'dotenv-rails'
gem 'sqlite3'
gem 'puma', '~> 3.7'

# gem 'jbuilder', '~> 2.5'
# gem 'redis', '~> 4.0'
# gem 'bcrypt', '~> 3.1.7'

# gem 'capistrano-rails', group: :development
gem 'rack-cors'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'guard-rspec', require: false
  gem 'rspec-rails'
  gem 'simplecov', require: false, group: :test
end

group :development do
  gem 'guard-rails'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'devise'
gem 'devise-jwt', '~> 0.5.6'
gem 'normalize_country'
gem 'mailgun_rails'
gem 'paypal-sdk-rest'
gem 'rubocop', require: false
