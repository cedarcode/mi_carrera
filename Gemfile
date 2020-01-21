source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '~> 6.0.0.a'

gem 'bootsnap', '~> 1.4', require: false
gem 'jbuilder', '~> 2.9'
gem 'pg', '~> 1.1'
gem 'puma', '~> 3.11'
gem 'rollbar', '~> 2.19'
gem 'sass-rails', '~> 5.0'
gem 'serviceworker-rails', '~> 0.6'
gem 'turbolinks', '~> 5.2'
gem 'uglifier', '~> 4.1'
gem 'webpacker', '~> 3.6'

# This is needed because of https://github.com/rails/sprockets/issues/567
gem "sprockets", "~> 4.0.a"

group :development, :test do
  gem 'byebug', '~> 11.0', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
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
