require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ConemoDashboard
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.active_record.default_timezone = :utc
    config.i18n.enforce_available_locales = false
    config.i18n.default_locale = :"pt-BR"

    config.active_record.observers = :call_to_schedule_final_appointment_observer,
                                     :final_appointment_observer,
                                     :first_appointment_observer,
                                     :first_contact_observer,
                                     :help_message_observer,
                                     :help_request_call_observer,
                                     :lack_of_connectivity_call_observer,
                                     :non_adherence_call_observer,
                                     :participant_observer,
                                     :second_contact_observer,
                                     :third_contact_observer
  end
end
