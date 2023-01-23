source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem 'rails', '~> 7.0.4.1'

gem 'bootsnap', '~> 1.4', require: false
gem 'devise', '~> 4.8'
gem 'importmap-rails', '~> 1.1'
gem 'jbuilder', '~> 2.9'
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", '~> 1.1'
gem "omniauth-rails_csrf_protection", '~> 1.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 4.3'
gem 'rollbar', '~> 2.19'
gem 'sassc-rails', '~> 2.1.2'
gem 'serviceworker-rails', '~> 0.6'
gem 'stimulus-rails', '~> 1.2'

group :development, :test do
  gem 'byebug', '~> 11.0', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "letter_opener", "~> 1.7"
  gem 'rubocop', '~> 1.43'
  gem 'rubocop-performance', '~> 1.15', require: false
  gem 'rubocop-rails', '~> 2.17', require: false
  gem 'web-console', '~> 4.0'
end

group :test do
  gem 'capybara', '~> 3.24'
  gem 'selenium-webdriver', '~> 4.0.0'
  gem "webdrivers", '~> 4.0'
end
