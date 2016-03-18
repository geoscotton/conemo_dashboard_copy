# frozen_string_literal: true
module Tasks
  # A scheduled task to complete the Initial in Person Appointment.
  class InitialInPersonAppointment < NurseTask
    OVERDUE_AFTER_DAYS = 3

    validates :participant_id, uniqueness: { scope: :type }

    def target
      symbolize FirstAppointment
    end
  end
end
