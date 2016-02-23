source "https://rubygems.org"

gem "rails", "~> 4.2.5"
gem "turbolinks", "= 2.5.3"
gem "pg", "= 0.18.4"
gem "sass-rails", "~> 5.0"
gem "uglifier"
gem "jquery-rails", "~> 3.1.3"
gem "jquery-ui-rails"
gem "devise", "~> 3.5.2"
gem "rails_admin", "~> 0.8.1"
gem "cancancan", "= 1.13.1"
gem "font-awesome-sass"
gem "coffee-script"
gem "jbuilder"
gem "ckeditor"
gem "twilio-ruby", "~> 3.11"
gem "normalize-rails"
gem "nokogiri", "= 1.6.3.1"
gem "sentry-raven", "~> 0.15.2"
# for model lifecycle hooks
gem "rails-observers", "~> 0.1.2"
# for business date calculations
gem "business_time", "= 0.7.4"

group :staging, :production do
  # scheduling tasks
  gem "whenever", require: false
end

group :development, :test do
  gem "rspec-rails", "~> 3.4"
  gem "rubocop", "= 0.36"
  gem "guard-rspec", require: false
  gem "spring-commands-rspec"
  gem "rb-fsevent"
  gem "terminal-notifier-guard"
end

group :development do
  gem "capistrano", "~> 3.2", require: false
  gem "capistrano-rails", "~> 1.1", require: false
  gem "capistrano-rvm", "~> 0.1", require: false
  gem "capistrano-bundler", "~> 1.1"
  gem "brakeman"
end

group :test do
  gem "capybara"
  gem "simplecov", "~> 0.10.0", require: false
  gem "poltergeist"
end

gem "bit_core", "~> 1.0"
gem "token_auth",
    git: "https://github.com/NU-CBITS/token_auth_server_rails",
    tag: "0.1.3"
gem "active_model_serializers", "= 0.10.0.rc3"
