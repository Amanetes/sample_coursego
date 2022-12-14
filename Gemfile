# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails', '~> 6.1.6', '>= 6.1.6.1'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'rubocop-rails', require: false
  gem 'rubocop-performance', require: false
  gem 'rails-erd'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'haml-rails', '~> 2.0'
gem 'font-awesome-sass', '~> 6.1.2'
gem 'simple_form'
gem 'faker'
gem 'devise'
gem 'friendly_id', '~> 5.4.0'
gem 'ransack'
gem 'public_activity'
gem 'rolify'
gem 'pundit'
gem 'exception_notification'
gem 'pagy'
gem 'recaptcha'
gem 'chartkick'
gem 'groupdate'
gem 'ranked-model' # give serial/index numbers to items in a list
gem 'aws-sdk-s3', require: false # save images and files in production
gem 'active_storage_validations' # validate image and file uploads
gem 'image_processing' # sudo apt install imagemagick
gem 'omniauth-google-oauth2' # sign in with google
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-facebook'
