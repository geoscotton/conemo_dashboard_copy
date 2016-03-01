# frozen_string_literal: true
module Tasks
  # A scheduled task to complete the week 1 follow up call.
  class FollowUpCallWeekOne < NurseTask
    OVERDUE_AFTER_DAYS = 3

    validates :user_id, uniqueness: { scope: [:participant_id, :type] }

    def target
      symbolize SecondContact
    end
  end
end
