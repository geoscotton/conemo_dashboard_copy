# frozen_string_literal: true
# Manage Nurse display.
class NurseDashboardsController < ApplicationController
  def show
    @nurse_dashboard = NurseDashboardPresenter.new(current_user)
    authorize! :read, @nurse_dashboard.participants
  end
end
