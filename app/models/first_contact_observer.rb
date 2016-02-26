# frozen_string_literal: true
# Hook into First Contact lifecycle events.
class FirstContactObserver < ActiveRecord::Observer
  def after_save(first_contact)
    Tasks::InitialInPersonAppointment.create(
      nurse: first_contact.participant.nurse,
      participant: first_contact.participant,
      scheduled_at: first_contact.first_appointment_at
    )
  end
end
