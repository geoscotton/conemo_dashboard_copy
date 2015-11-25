require "raven"
require "conemo_dashboard"

Raven.configure do |config|
  config.environments = %w( staging production )
  config.excluded_exceptions = %w(
    URI::InvalidURIError
    ActionController::UnknownHttpMethod
  )
  dsn = Rails.application.config.try(:sentry_dsn)
  config.dsn = dsn if dsn
  config.release = ConemoDashboard::VERSION
end
