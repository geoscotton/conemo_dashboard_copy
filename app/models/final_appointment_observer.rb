# frozen_string_literal: true
# Hook into First Appointment lifecycle events.
class FinalAppointmentObserver < ActiveRecord::Observer
  def after_create(final_appointment)
    Tasks::FinalInPersonAppointment.active.find_by(
      participant: final_appointment.participant
    ).try(:resolve)

    final_appointment.participant.complete
  end
end
