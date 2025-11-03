source 'https://rubygems.org'

ruby file: ".ruby-version"

gem 'rails', '~> 8.0.4'

gem 'appsignal', '~> 4.7'
gem 'bootsnap', '~> 1.18', require: false
gem 'devise', '~> 4.9'
gem 'factory_bot_rails', '~> 6.5'
gem 'importmap-rails', '~> 2.2'
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", '~> 1.2'
gem "omniauth-rails_csrf_protection", '~> 1.0'
gem 'pdf-reader'
gem 'pg', '~> 1.6'
gem 'propshaft', '~> 1.3'
gem 'puma', '~> 7.1'
gem 'rollbar', '~> 3.6'
gem 'stimulus-rails', '~> 1.3'
gem 'tailwindcss-rails', '~> 4.3'
gem 'turbo-rails', '~> 2.0'
gem "view_component", "~> 4.1"
gem 'webauthn'

group :development, :deploy do
  gem 'kamal'
end

group :development, :test do
  gem "brakeman", "~> 7.1"
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 8.0'
end

group :development do
  gem "annotaterb", "~> 4.20"
  gem "letter_opener", "~> 1.10"
  gem "lookbook", "~> 2.3"
  gem 'rubocop', '~> 1.81'
  gem 'rubocop-performance', '~> 1.26', require: false
  gem 'rubocop-rails', '~> 2.33', require: false
  gem 'web-console', '~> 4.2'
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver', '~> 4.38'
  gem 'shoulda-matchers', '~> 6.5'
  gem 'simplecov', require: false
end
