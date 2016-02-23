# Manage Nurse display.
class NurseDashboardsController < ApplicationController
  def show
    @participants = Participant
                    .where(nurse: current_user)
                    .active
    authorize! :read, @participants
  end
end
