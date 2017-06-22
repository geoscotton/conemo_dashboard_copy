# frozen_string_literal: true
# Hook into First Contact lifecycle events.
class FirstContactObserver < ActiveRecord::Observer
  def after_save(first_contact)
    Tasks::InitialInPersonAppointment.create(
      participant: first_contact.participant,
      scheduled_at: first_contact.first_appointment_at
    )

    Tasks::ConfirmationCall.active.find_by(
      participant: first_contact.participant
    ).try(:resolve)
  end
end
