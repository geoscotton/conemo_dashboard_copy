# frozen_string_literal: true
# Hook into First Appointment lifecycle events.
class FirstAppointmentObserver < ActiveRecord::Observer
  def after_save(first_appointment)
    Tasks::FollowUpCallWeekOne.create(
      participant: first_appointment.participant,
      scheduled_at: first_appointment.appointment_at + 1.week
    )

    Tasks::FollowUpCallWeekThree.create(
      participant: first_appointment.participant,
      scheduled_at: first_appointment.appointment_at + 3.weeks
    )

    Tasks::CallToScheduleFinalAppointment.create(
      participant: first_appointment.participant,
      scheduled_at: first_appointment.appointment_at + 6.weeks
    )

    Tasks::InitialInPersonAppointment.active.find_by(
      participant: first_appointment.participant
    ).try(:resolve)
  end
end
