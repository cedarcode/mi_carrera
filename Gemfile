source 'https://rubygems.org'

ruby file: ".ruby-version"

gem 'rails', '~> 8.0.2'

gem 'bootsnap', '~> 1.18', require: false
gem 'devise', '~> 4.9'
gem 'factory_bot_rails', '~> 6.4'
gem 'importmap-rails', '~> 2.1'
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", '~> 1.2'
gem "omniauth-rails_csrf_protection", '~> 1.0'
gem 'pg', '~> 1.5'
gem 'propshaft', '~> 1.1'
gem 'puma', '~> 6.6'
gem 'rollbar', '~> 3.6'
gem 'stimulus-rails', '~> 1.3'
gem 'tailwindcss-rails', '~> 4.1'
gem 'turbo-rails', '~> 2.0'
gem "view_component", "~> 3.22"

group :development, :deploy do
  gem 'kamal'
end

group :development, :test do
  gem "brakeman", "~> 7.0"
  gem 'byebug', '~> 12.0', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 7.1'
end

group :development do
  gem "letter_opener", "~> 1.10"
  gem 'rubocop', '~> 1.75'
  gem 'rubocop-performance', '~> 1.25', require: false
  gem 'rubocop-rails', '~> 2.31', require: false
  gem 'web-console', '~> 4.2'
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver', '~> 4.31'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'simplecov', require: false
end
