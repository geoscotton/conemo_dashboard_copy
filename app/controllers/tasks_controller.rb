# Manage Nurse Tasks for a Participant.
class TasksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @tasks = NurseTask.for_nurse_and_participant(current_user, find_participant)
    authorize! :update, @tasks
  end

  private

  def find_participant
    @participant ||= Participant.active.find(params[:participant_id])
  end

  def record_not_found
    redirect_to active_participants_url, alert: "Participant not found"
  end
end
