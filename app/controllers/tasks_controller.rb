# frozen_string_literal: true
# Manage Nurse Tasks for a Participant.
class TasksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    tasks = NurseTask.for_nurse_and_participant(current_user, find_participant)
    @tasks = ParticipantSummaryPresenter.new(find_participant, tasks)
    authorize! :update, tasks
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
