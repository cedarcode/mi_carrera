source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem 'rails', '~> 7.0.4.3'

gem 'bootsnap', '~> 1.4', require: false
gem 'devise', '~> 4.9'
gem 'factory_bot_rails', '~> 6.2'
gem 'importmap-rails', '~> 1.1'
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", '~> 1.1'
gem "omniauth-rails_csrf_protection", '~> 1.0'
gem 'pg', '~> 1.4'
gem 'puma', '~> 6.1'
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
  gem 'rubocop', '~> 1.48'
  gem 'rubocop-performance', '~> 1.16', require: false
  gem 'rubocop-rails', '~> 2.18', require: false
  gem 'web-console', '~> 4.0'
end

group :test do
  gem 'capybara', '~> 3.24'
  gem 'selenium-webdriver', '~> 4.8'
  gem "webdrivers", '~> 5.2'
end
