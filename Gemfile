source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'rails', '~> 5.2.2'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'jbuilder', '~> 2.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rollbar', '~> 2.19'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

# This is needed because of https://github.com/rails/sprockets/issues/567
gem "sprockets", "~> 4.0.a"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '0.65.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
