# Controller superclass.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :authenticate_user!
  before_action :authorize_locale
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
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end

  def authorize_locale
    if current_user
      if current_user.nurse? && current_user.locale != params[:locale]
        redirect_to root_path(locale: current_user.locale)
      end
    end
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.timezone, &block)
  end
end
