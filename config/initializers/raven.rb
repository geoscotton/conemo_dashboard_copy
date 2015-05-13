require "raven"

Raven.configure do |config|
  config.environments = %w( staging production )
  config.excluded_exceptions = [
    "URI::InvalidURIError",
    "ActionController::UnknownHttpMethod"
  ]
  dsn = Rails.application.config.try(:sentry_dsn)
  config.dsn = dsn if dsn
end
