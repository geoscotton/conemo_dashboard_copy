# frozen_string_literal: true
# Cancel Scheduled Nurse Tasks for a Participant.
class ScheduledTaskReschedulingsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @scheduled_task_rescheduling =
      ScheduledTaskRescheduling.new(nurse_task: find_task)
    authorize! :create, @scheduled_task_rescheduling
  end

  def create
    @scheduled_task_rescheduling =
      ScheduledTaskRescheduling.new(rescheduling_params)
    authorize! :create, @scheduled_task_rescheduling

    if find_task.reschedule_at(scheduled_at) &&
       @scheduled_task_rescheduling.save
      flash[:notice] = "#{find_task.model_name.human} successfully rescheduled"
    else
      flash[:alert] = "Error rescheduling #{find_task.model_name.human}: " +
                      find_task.errors.full_messages.join(", ")
    end

    redirect_to participant_tasks_url(find_participant)
  end

  private

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "#{Participant.model_name.human} not found"
  end

  def rescheduling_params
    params.require(:scheduled_task_rescheduling)
          .permit(:explanation, :notes, :scheduled_at)
          .merge(nurse_task: find_task,
                 old_scheduled_at: find_task.scheduled_at)
  end

  def find_participant
    @participant ||=
      current_user.active_participants.find(params[:participant_id])
  end

  def find_task
    @task ||= NurseTask.for_participant(find_participant)
                       .find(params[:task_id])
  end

  def scheduled_at
    return unless rescheduling_params["scheduled_at(1i)"]

    Time.zone.local(
      *(1..5).map { |i| rescheduling_params["scheduled_at(#{i}i)"] }
    )
  end
end
