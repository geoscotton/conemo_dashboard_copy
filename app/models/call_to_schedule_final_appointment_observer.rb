# frozen_string_literal: true
# Hook into Call to Schedule Final Appointment lifecycle events.
class CallToScheduleFinalAppointmentObserver < ActiveRecord::Observer
  def after_save(scheduling_call)
    Tasks::FinalInPersonAppointment.create(
      nurse: scheduling_call.participant.nurse,
      participant: scheduling_call.participant,
      scheduled_at: scheduling_call.final_appointment_at
    )
  end
end
