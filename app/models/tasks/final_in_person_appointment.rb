module Tasks
  # A scheduled task to complete the Final in Person Appointment.
  class FinalInPersonAppointment < NurseTask
    OVERDUE_AFTER_DAYS = 3
  end
end
