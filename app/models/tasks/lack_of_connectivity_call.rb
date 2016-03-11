# frozen_string_literal: true
module Tasks
  # A triggered task to call about lack of connectivity.
  class LackOfConnectivityCall < NurseTask
    OVERDUE_AFTER_DAYS = 2

    validates :user_id,
              uniqueness: {
                scope: [:participant_id, :type],
                conditions: -> { where(status: NurseTask::STATUSES.active) }
              }

    def alert?
      true
    end

    def target
      symbolize ::LackOfConnectivityCall
    end
  end
end
