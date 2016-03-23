# frozen_string_literal: true
# Cancel Scheduled Nurse Tasks for a Participant.
class ScheduledTaskCancellationsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @scheduled_task_cancellation =
      ScheduledTaskCancellation.new(nurse_task: find_task)
    authorize! :create, @scheduled_task_cancellation
  end

  def create
    @scheduled_task_cancellation =
      ScheduledTaskCancellation.new(cancellation_params)
    authorize! :create, @scheduled_task_cancellation

    if find_task.cancel && @scheduled_task_cancellation.save
      flash[:notice] = "#{find_task.model_name.human} successfully cancelled"
    else
      flash[:alert] = "Error cancelling #{find_task.model_name.human}: " +
                      find_task.errors.full_messages.join(", ")
    end

    redirect_to participant_tasks_url(find_participant)
  end

  private

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "#{Participant.model_name.human} not found"
  end

  def cancellation_params
    params.require(:scheduled_task_cancellation).permit(:explanation)
          .merge(nurse_task: find_task)
  end

  def find_participant
    @participant ||=
      current_user.active_participants.find(params[:participant_id])
  end

  def find_task
    @task ||= NurseTask.for_participant(find_participant)
                       .find(params[:task_id])
  end
end
