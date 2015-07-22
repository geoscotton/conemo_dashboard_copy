source "https://rubygems.org"

gem "rails", "= 4.1.11"
gem "turbolinks"
gem "pg"
gem "sass-rails", "~> 4.0.2"
gem "bootstrap-sass"
gem "uglifier"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "devise"
gem "rails_admin"
gem "cancan"
gem "font-awesome-sass"
gem "coffee-script"
gem "jbuilder"
gem "ckeditor"
gem "twilio-ruby"
gem "normalize-rails"
gem "nokogiri", "= 1.6.3.1"

gem "sentry-raven",
    git: "https://github.com/getsentry/raven-ruby.git",
    tag: "0.13.3"

group :staging, :production do
  # scheduling tasks
  gem "whenever", require: false
end

group :development, :test do
  gem "rspec-rails", "~> 3.0.0.beta"
  gem "simplecov", "~> 0.9.1"
  gem "rubocop", "~> 0.28"
end

group :development do
  gem "capistrano", "~> 3.2.0", require: false
  gem "capistrano-rails", "~> 1.1", require: false
  gem "capistrano-rvm", "~> 0.1", require: false
  gem "capistrano-bundler", "~> 1.1.2"
  gem "spring"
  gem "spring-commands-rspec"
  gem "brakeman"
end

group :test do
  gem "capybara"
  gem "database_cleaner"
end

gem "bit_core", "~> 1.0"
