# The general entry point for the site.
class DashboardsController < ApplicationController
  layout "dashboard"

  def index
    if current_user.role == "nurse"
      redirect_to active_participants_path
    end
  end
end
