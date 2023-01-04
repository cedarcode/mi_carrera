source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem 'rails', '~> 6.0.6'

gem 'bootsnap', '~> 1.4', require: false
gem 'devise', '~> 4.8'
gem 'jbuilder', '~> 2.9'
gem 'kimurai', "~> 1.4"
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", '~> 1.1'
gem "omniauth-rails_csrf_protection", '~> 1.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 4.3'
gem 'rollbar', '~> 2.19'
gem 'sass-rails', '~> 6.0'
gem 'serviceworker-rails', '~> 0.6'
gem 'turbolinks', '~> 5.2'
gem 'uglifier', '~> 4.1'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'byebug', '~> 11.0', platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails", "~> 2.7"
end

group :development do
  gem "letter_opener", "~> 1.7"
  gem 'listen', '~> 3.1'
  gem 'rubocop', '~> 0.67.0'
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 4.0'
end

group :test do
  gem 'capybara', '~> 3.24'
  gem 'selenium-webdriver', '~> 3.142'
  gem "webdrivers", '~> 4.0'
end
