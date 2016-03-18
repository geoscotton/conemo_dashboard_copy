# frozen_string_literal: true
module Tasks
  # A scheduled task to complete the week 3 follow up call.
  class FollowUpCallWeekThree < NurseTask
    OVERDUE_AFTER_DAYS = 3

    validates :participant_id, uniqueness: { scope: :type }

    def target
      symbolize ThirdContact
    end
  end
end
