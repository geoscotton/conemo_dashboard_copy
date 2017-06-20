# frozen_string_literal: true
# Controller superclass.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  before_action :set_locale,
                :authenticate_user!,
                :authorize_locale,
                :set_raven_user_context
  around_action :user_time_zone, if: :current_user

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller?
      if controller_name == "sessions" && action_name == "new"
        "login"
      else
        "dashboard"
      end
    else
      "application"
    end
  end

  def set_locale
    I18n.locale = params[:locale] || current_user.try(:locale) || I18n.default_locale
  end

  def self.default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

  def authorize_locale
    return if current_user.nil? || current_user.is_a?(Superuser)

    return if current_user.locale == params[:locale]

    redirect_to main_app.root_url(locale: current_user.locale)
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.timezone, &block)
  end

  def set_raven_user_context
    Raven.user_context(id: current_user.try(:id))
  end
end
