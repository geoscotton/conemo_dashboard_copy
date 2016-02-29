# frozen_string_literal: true
# Manage Nurse Tasks for a Participant.
class TasksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    tasks = NurseTask.for_nurse_and_participant(current_user, find_participant)
    @tasks = ParticipantSummaryPresenter.new(find_participant, tasks)
    authorize! :update, tasks
  end

  def resolve
    task = NurseTask.for_nurse_and_participant(current_user, find_participant)
                    .find(params[:id])

    if task.resolve
      flash[:notice] = "Task successfully resolved"
    else
      flash[:alert] = "Error resolving task: #{task.errors.full_messages}"
    end

    redirect_to participant_tasks_url(find_participant)
  end

  def notify_supervisor
    task = NurseTask.for_nurse_and_participant(current_user, find_participant)
                    .find(params[:id])

    notification = SupervisorNotification.new(
      nurse: current_user,
      nurse_supervisor: current_user.nurse_supervisor,
      nurse_task: task
    )
    if notification.save
      flash[:notice] = "a notification has been sent for your supervisor " \
                       "to review this issue"
    else
      flash[:alert] = "Error notifying supervisor"
    end

    redirect_to participant_tasks_url(find_participant)
  end

  private

  def find_participant
    @participant ||=
      current_user.active_participants.find(params[:participant_id])
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
