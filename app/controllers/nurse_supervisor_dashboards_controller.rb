# frozen_string_literal: true
# Manage Nurse Supervisor display.
class NurseSupervisorDashboardsController < ApplicationController
  def show
    participants = Participant.where(nurse: current_user.nurses)
    @pending_participants = participants.pending
    @completed_participants = participants.completed
    @dropped_out_participants = participants.ineligible
    @nurses = current_user.nurses
    authorize! :update, @pending_participants
  end
end
