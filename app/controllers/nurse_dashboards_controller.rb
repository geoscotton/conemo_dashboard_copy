# Manage Nurse display.
class NurseDashboardsController < ApplicationController
  def show
    @participants = Participant
                    .where(nurse: current_user)
                    .active
    @tasks = NurseTask
             .where(nurse: current_user, participant: @participants)
             .where(status: NurseTask::STATUSES.active)
             .group_by(&:participant_id)
    authorize! :read, @participants
  end
end
