# Controller superclass.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :authenticate_user!

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
end
