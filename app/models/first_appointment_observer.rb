# frozen_string_literal: true
# Hook into First Appointment lifecycle events.
class FirstAppointmentObserver < ActiveRecord::Observer
  def after_save(first_appointment)
    Tasks::FollowUpCallWeekOne.create(
      nurse: first_appointment.participant.nurse,
      participant: first_appointment.participant,
      scheduled_at: first_appointment.next_contact
    )

    Tasks::FollowUpCallWeekThree.create(
      nurse: first_appointment.participant.nurse,
      participant: first_appointment.participant,
      scheduled_at: first_appointment.next_contact + 2.weeks
    )

    Tasks::CallToScheduleFinalAppointment.create(
      nurse: first_appointment.participant.nurse,
      participant: first_appointment.participant,
      scheduled_at: first_appointment.next_contact + 5.weeks
    )
  end

  def after_create(first_appointment)
    Tasks::InitialInPersonAppointment.active.find_by(
      participant: first_appointment.participant
    ).try(:resolve)
  end
end
