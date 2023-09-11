source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem 'rails', '~> 7.0.8'

gem 'bootsnap', '~> 1.4', require: false
gem 'devise', '~> 4.9'
gem 'factory_bot_rails', '~> 6.2'
gem 'importmap-rails', '~> 1.2'
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", '~> 1.1'
gem "omniauth-rails_csrf_protection", '~> 1.0'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.3'
gem 'rollbar', '~> 3.4'
gem 'sassc-rails', '~> 2.1.2'
gem 'serviceworker-rails', '~> 0.6'
gem 'stimulus-rails', '~> 1.2'
gem 'turbo-rails', '~> 1.4'

group :development, :test do
  gem 'byebug', '~> 11.0', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "letter_opener", "~> 1.7"
  gem 'rubocop', '~> 1.56'
  gem 'rubocop-performance', '~> 1.19', require: false
  gem 'rubocop-rails', '~> 2.20', require: false
  gem 'web-console', '~> 4.0'
end

group :test do
  gem 'capybara', '~> 3.39'
  gem 'selenium-webdriver', '~> 4.12'
end
