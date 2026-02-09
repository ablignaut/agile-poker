source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '>= 3.2.0'

gem 'rails', '~> 8.1.0'
gem 'pg'
gem 'puma', '>= 5.0'
gem 'sass-rails', '>= 6'
gem 'jsbundling-rails'
gem 'turbo-rails'
gem 'jbuilder'
gem 'bootsnap', require: false

gem 'redis'
gem 'haml'
gem 'simple_form'

group :development, :test do
  gem 'haml-rails', '~> 2.0.1'
  gem 'debug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console'
  gem 'rack-mini-profiler'
  gem 'pry-rails'
  gem 'better_errors'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
