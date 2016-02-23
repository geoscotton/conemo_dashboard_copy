module Tasks
  # A scheduled task to complete the Initial in Person Appointment.
  class InitialInPersonAppointment < NurseTask
    OVERDUE_AFTER_DAYS = 3
  end
end
