# frozen_string_literal: true
module Tasks
  # A scheduled task to complete the Final in Person Appointment.
  class FinalInPersonAppointment < NurseTask
    OVERDUE_AFTER_DAYS = 2

    validates :participant_id, uniqueness: { scope: :type }

    def target
      symbolize FinalAppointment
    end
  end
end
