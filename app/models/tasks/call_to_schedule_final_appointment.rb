module Tasks
  # A scheduled task to complete the call to schedule final in person
  # appointment.
  class CallToScheduleFinalAppointment < NurseTask
    OVERDUE_AFTER_DAYS = 3
  end
end
