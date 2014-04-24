source "https://rubygems.org"

gem "rails", "~> 4.1"
gem "turbolinks"
gem "pg"
gem "sass-rails"
gem "bootstrap-sass"
gem "uglifier"
gem "jquery-rails"
gem "devise"
gem "rails_admin"
gem "cancan"
gem "font-awesome-sass"

group :staging, :production do
  # email exceptions
  gem "exception_notification", "~> 4.1.0.rc1"
  # scheduling tasks
  gem "whenever"
end

group :development, :test do
  gem "rspec-rails", "~> 3.0.0.beta"
end

group :development do
  gem "capistrano", "~> 3.2.0", require: false
  gem "capistrano-rails", "~> 1.1", require: false
  gem "capistrano-rvm", "~> 0.1", require: false
  gem "capistrano-bundler", "~> 1.1.2"
  gem "debugger"
  gem "spring"
  gem "spring-commands-rspec"
end

group :test do
  gem "capybara"
end

gem "bit_core", "~> 1.0"
