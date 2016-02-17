# The general entry point for the site.
class DashboardsController < ApplicationController
  layout "dashboard"

  def index
    if current_user.nurse?
      redirect_to active_participants_url
    elsif current_user.nurse_supervisor?
      redirect_to nurse_supervisor_dashboard_url
    end
  end
end
