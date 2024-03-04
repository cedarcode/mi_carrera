source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'rails', '~> 7.1.3'

gem 'bootsnap', '~> 1.18', require: false
gem 'devise', '~> 4.9'
gem 'factory_bot_rails', '~> 6.4'
gem 'importmap-rails', '~> 2.0'
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", '~> 1.1'
gem "omniauth-rails_csrf_protection", '~> 1.0'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'rollbar', '~> 3.5'
gem 'sassc-rails', '~> 2.1.2'
gem 'serviceworker-rails', '~> 0.6'
gem 'stimulus-rails', '~> 1.3'
gem 'turbo-rails', '~> 1.5'

group :development, :test do
  gem 'byebug', '~> 11.0', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'kamal', '~> 1.3'
  gem "letter_opener", "~> 1.9"
  gem 'rubocop', '~> 1.61'
  gem 'rubocop-performance', '~> 1.20', require: false
  gem 'rubocop-rails', '~> 2.23', require: false
  gem 'web-console', '~> 4.2'
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver', '~> 4.18'
end
