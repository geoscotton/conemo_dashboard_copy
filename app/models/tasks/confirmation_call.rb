# frozen_string_literal: true
module Tasks
  # A scheduled task to complete a Confirmation Call.
  class ConfirmationCall < NurseTask
    OVERDUE_AFTER_DAYS = 3

    validates :participant_id, uniqueness: { scope: :type }

    def target
      symbolize FirstContact
    end
  end
end
