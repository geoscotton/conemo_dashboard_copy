module Tasks
  # A scheduled task to complete a Confirmation Call.
  class ConfirmationCall < NurseTask
    OVERDUE_AFTER_DAYS = 3

    validates :user_id, uniqueness: { scope: [:participant_id, :type] }
  end
end
