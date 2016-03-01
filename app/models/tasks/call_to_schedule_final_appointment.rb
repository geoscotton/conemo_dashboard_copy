# frozen_string_literal: true
module Tasks
  # A scheduled task to complete the call to schedule final in person
  # appointment.
  class CallToScheduleFinalAppointment < NurseTask
    OVERDUE_AFTER_DAYS = 3

    validates :user_id, uniqueness: { scope: [:participant_id, :type] }

    def target
      symbolize ::CallToScheduleFinalAppointment
    end
  end
end
