# frozen_string_literal: true
# Manage Notifications for a Supervisor.
class SupervisorNotificationsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def clear
    if find_notification.resolve
      flash[:notice] = SupervisorNotification.model_name.human +
                       " successfully cleared"
    else
      flash[:alert] = "Error clearing task: " +
                      SupervisorNotification.model_name.human +
                      find_notification.errors.full_messages.join(", ")
    end

    redirect_to root_url
  end

  private

  def find_notification
    @supervisor_notification ||= SupervisorNotification
                                 .active_for_nurse(find_nurse)
                                 .first
  end

  def find_nurse
    @participant ||=
      current_user.nurses.find(params[:nurse_id])
  end

  def record_not_found
    redirect_to root_url, alert: "#{Nurse.model_name.human} not found"
  end
end
