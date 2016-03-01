# frozen_string_literal: true
module Tasks
  # A scheduled task to complete the Final in Person Appointment.
  class FinalInPersonAppointment < NurseTask
    OVERDUE_AFTER_DAYS = 3

    validates :user_id, uniqueness: { scope: [:participant_id, :type] }

    def target
      symbolize FinalAppointment
    end
  end
end
