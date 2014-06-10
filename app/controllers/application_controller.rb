# Controller superclass.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :authenticate_user!
  before_filter :authorize_locale
  before_filter :set_timezone

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == "new"
      "dashboard"
    else
      "application"
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }
  end

  def authorize_locale
    if current_user 
      if current_user.nurse? && current_user.locale != params[:locale]
        redirect_to root_path(locale: current_user.locale)
      end
    end
  end

  def set_timezone
    Time.zone = cookies["time_zone"]
  end
end