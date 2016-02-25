module Tasks
  # A triggered task to call about lack of connectivity.
  class LackOfConnectivityCall < NurseTask
    OVERDUE_AFTER_DAYS = 2

    validates :user_id,
              uniqueness: { scope: [:participant_id, :type, :status] }
  end
end
