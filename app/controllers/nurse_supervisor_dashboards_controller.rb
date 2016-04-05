# frozen_string_literal: true
# Manage Nurse Supervisor display.
class NurseSupervisorDashboardsController < ApplicationController
  def show
    participants = Participant.where(nurse: current_user.nurses)
    @pending_participants = Participant.pending
                                       .where(locale: current_user.locale)
    @active_participants = participants.active
    @completed_participants = participants.completed
    @dropped_out_participants = participants.dropped_out
    @nurses = current_user.nurses
    authorize! :update, @pending_participants
  end
end
