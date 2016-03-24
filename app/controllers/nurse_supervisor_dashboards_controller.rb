# frozen_string_literal: true
# Manage Nurse Supervisor display.
class NurseSupervisorDashboardsController < ApplicationController
  def show
    @pending_participants = Participant
                            .where(locale: current_user.locale)
                            .pending
    @nurses = current_user.nurses
    authorize! :update, @pending_participants
  end
end
