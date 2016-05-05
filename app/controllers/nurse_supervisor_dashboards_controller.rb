# frozen_string_literal: true
# Manage Nurse Supervisor display.
class NurseSupervisorDashboardsController < ApplicationController
  def show
    return redirect_to(root_url) unless current_user.respond_to?(:nurses)

    participants = Participant.where(nurse: current_user.nurses).includes(:nurse)
    @pending_participants = Participant.pending
                                       .where(locale: current_user.locale)
                                       .includes(:nurse)
    @active_participants = participants.active
    @completed_participants = participants.completed
    @dropped_out_participants = participants.dropped_out
    @dashboard = NurseSupervisorDashboardPresenter.new(current_user,
                                                       @active_participants)
    authorize! :update, @pending_participants
  end
end
