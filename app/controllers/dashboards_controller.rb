# frozen_string_literal: true
# The general entry point for the site.
class DashboardsController < ApplicationController
  layout "dashboard"

  def index
    if current_user.nurse?
      redirect_to nurse_dashboard_url
    elsif current_user.nurse_supervisor?
      redirect_to nurse_supervisor_dashboard_url
    elsif current_user.admin?
      redirect_to pending_participants_url
    elsif current_user.is_a? Superuser
      redirect_to rails_admin_url
    end
  end
end
