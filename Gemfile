source 'https://rubygems.org'

ruby file: ".ruby-version"

gem 'rails', '~> 8.1.1'

gem 'appsignal', '~> 4.10'
gem 'bootsnap', '~> 1.25', require: false
gem 'devise', '~> 5.0'
gem "devise-webauthn", "~> 0.5.0"
gem 'factory_bot_rails', '~> 6.5'
gem 'importmap-rails', '~> 2.2'
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", '~> 1.2'
gem "omniauth-rails_csrf_protection", '~> 2.0'
gem 'pdf-reader'
gem 'pg', '~> 1.6'
gem 'propshaft', '~> 1.3'
gem 'puma', '~> 8.0'
gem 'stimulus-rails', '~> 1.3'
gem 'tailwindcss-rails', '~> 4.6'
gem 'turbo-rails', '~> 2.0'
gem "view_component", "~> 4.12"
gem 'webauthn'

group :development, :deploy do
  gem 'kamal'
end

group :development, :test do
  gem "brakeman", "~> 8.0"
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 8.0'
end

group :development do
  gem "annotaterb", "~> 4.24"
  gem "letter_opener", "~> 1.10"
  gem "lookbook", "~> 2.3"
  gem 'rubocop', '~> 1.89'
  gem 'rubocop-performance', '~> 1.27', require: false
  gem 'rubocop-rails', '~> 2.37', require: false
  gem 'web-console', '~> 4.3'
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver', '~> 4.47'
  gem 'shoulda-matchers', '~> 8.0'
  # TODO: unpin this once https://github.com/joshmfrankel/simplecov-check-action/issues/37 is fixed
  gem 'simplecov', '< 1', require: false
end
