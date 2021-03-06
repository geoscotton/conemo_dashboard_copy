# frozen_string_literal: true
module Tasks
  # A triggered task to call about lack of adherence.
  class NonAdherenceCall < NurseTask
    OVERDUE_AFTER_DAYS = 1

    validates :participant_id,
              uniqueness: {
                scope: :type,
                conditions: -> { where(status: NurseTask::STATUSES.active) }
              }

    def alert?
      true
    end

    def target
      symbolize ::NonAdherenceCall
    end
  end
end
