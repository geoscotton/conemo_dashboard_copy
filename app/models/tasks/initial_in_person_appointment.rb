# frozen_string_literal: true
module Tasks
  # A scheduled task to complete the Initial in Person Appointment.
  class InitialInPersonAppointment < NurseTask
    OVERDUE_AFTER_DAYS = 3

    validates :user_id, uniqueness: { scope: [:participant_id, :type] }

    def target
      symbolize FirstAppointment
    end
  end
end
