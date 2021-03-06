# frozen_string_literal: true
# Manage Nurse Tasks for a Participant.
class TasksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    unless current_user.nurse? || current_user.nurse_supervisor?
      return redirect_to(root_url)
    end

    tasks = NurseTask.for_participant(find_participant)
    @tasks = ParticipantSummaryPresenter.new(find_participant, tasks)
    authorize! :read, tasks
  end

  def resolve
    if find_task.resolve
      flash[:notice] = "Task successfully resolved"
    else
      flash[:alert] = "Error resolving task: #{find_task.errors.full_messages}"
    end

    redirect_to participant_tasks_url(find_participant)
  end

  def notify_supervisor
    notification = SupervisorNotification.new(nurse_task: find_task)

    if notification.save
      flash[:notice] =
        t("actioncontroller.tasks.notify_supervisor.flash_notice")
    else
      errors = notification.errors.full_messages.join(", ")
      flash[:alert] = "Error notifying supervisor: #{errors}"
    end

    redirect_to participant_tasks_url(find_participant)
  end

  def clear_latest_supervisor_notification
    notification = SupervisorNotification.latest_for(find_task)

    if notification.destroy
      flash[:notice] = "Notification successfully cleared"
    else
      errors = notification.errors.full_messages.join(", ")
      flash[:alert] = "Error clearing notification: #{errors}"
    end

    redirect_to participant_tasks_url(find_participant)
  end

  private

  def find_task
    @task ||= NurseTask.for_participant(find_participant)
                       .find(params[:id])
  end

  def find_participant
    @participant ||=
      current_user.active_participants.find(params[:participant_id])
  end

  def record_not_found
    if Participant.where(status: Participant::COMPLETED)
                  .exists?(id: params[:participant_id])
      redirect_to nurse_dashboard_url(current_user),
                  notice: t("actioncontroller.tasks.successfully_completed" \
                            ".flash_notice")
    else
      redirect_to nurse_dashboard_url(current_user),
                  alert: "Participant not found"
    end
  end
end
