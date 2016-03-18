# frozen_string_literal: true
module Tasks
  # A triggered task to respond to a Help Message.
  class HelpRequest < NurseTask
    OVERDUE_AFTER_DAYS = 2

    validates :participant_id,
              uniqueness: {
                scope: :type,
                conditions: -> { where(status: NurseTask::STATUSES.active) }
              }

    def alert?
      true
    end

    def target
      symbolize ::HelpRequestCall
    end
  end
end
