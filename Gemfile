# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1', '>= 6.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'decent_exposure'
gem 'slim-rails'

# AUTH
gem 'devise', github: 'heartcombo/devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'

# An OAuth 2 provider
gem 'doorkeeper'

gem 'aws-sdk-s3', require: false

# Form builder to handle nested forms
gem 'cocoon'

# Share Ruby variables to JS files
gem 'gon'

# Manage abilities
gem 'cancancan'

# JSON generation
gem 'active_model_serializers', '~> 0.10'

# JSON parser and Object marshaller
gem 'oj'

# Background processing for Ruby
gem 'sidekiq'

# Web-application for Sidekiq monitoring requires sinatra gem
gem 'sinatra', require: false

# Provides a clear syntax for writing and deploying cron jobs
gem 'whenever', require: false

# Integrations for Elasticsearch
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# App server for production
gem 'unicorn'

gem 'redis-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-byebug'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'

  gem 'action-cable-testing'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'

  # A documentation generation tool
  gem 'yard'

  # Shim to load environment variables.
  gem 'dotenv-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Opens e-mails in the browser
  gem 'letter_opener'

  # Framework for building automated deployment scripts
  gem 'capistrano', require: false

  # Adds specific tasks for Capistrano
  gem 'capistrano-bundler', require: false
  # gem 'capistrano-passenger', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'

  # Tests messages in Capybara integration tests
  gem 'capybara-email'

  gem 'selenium-webdriver'

  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  # Provides RSpec- and Minitest-compatible one-liners to test common Rails functionality
  gem 'shoulda-matchers'

  # Launching external applications from within ruby programs (currently only a browser is supported)
  gem 'launchy'

  # Validate the JSON returned by API
  gem 'json_matchers'

  gem 'elasticsearch-extensions'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
