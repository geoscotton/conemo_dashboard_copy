# frozen_string_literal: true
module Tasks
  # A scheduled task to complete the week 3 follow up call.
  class FollowUpCallWeekThree < NurseTask
    OVERDUE_AFTER_DAYS = 3

    validates :user_id, uniqueness: { scope: [:participant_id, :type] }

    def target
      symbolize ThirdContact
    end
  end
end
