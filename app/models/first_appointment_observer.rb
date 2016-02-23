# Hook into First Appointment lifecycle events.
class FirstAppointmentObserver < ActiveRecord::Observer
  def after_save(first_appointment)
    Tasks::FollowUpCallWeekOne.create(
      nurse: first_appointment.participant.nurse,
      participant: first_appointment.participant,
      scheduled_at: first_appointment.next_contact
    )
  end
end
