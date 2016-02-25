module Tasks
  # A triggered task to respond to a Help Message.
  class HelpRequest < NurseTask
    OVERDUE_AFTER_DAYS = 2

    validates :user_id,
              uniqueness: { scope: [:participant_id, :type, :status] }
  end
end