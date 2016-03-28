# frozen_string_literal: true
# Manage Nurse Supervisor display.
class NurseSupervisorDashboardsController < ApplicationController
  def show
    @pending_participants = Participant
                            .where(nurse: current_user.nurses)
                            .pending
    @completed_participants = Participant
                              .where(nurse: current_user.nurses)
                              .completed
    @nurses = current_user.nurses
    authorize! :update, @pending_participants
  end
end
