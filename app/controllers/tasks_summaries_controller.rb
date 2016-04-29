# frozen_string_literal: true
# Manage Nurse Tasks display for Supervisors.
class TasksSummariesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    return redirect_to(root_url) unless current_user.respond_to?(:nurses)

    @nurse_dashboard = NurseDashboardPresenter.new(find_nurse)
    authorize! :read, @nurse_dashboard.participants
  end

  private

  def find_nurse
    @nurse ||= current_user.nurses.find(params[:nurse_id])
  end

  def record_not_found
    redirect_to nurse_supervisor_dashboard_url,
                alert: Nurse.model_name.human + " " + t(".not_found")
  end
end
