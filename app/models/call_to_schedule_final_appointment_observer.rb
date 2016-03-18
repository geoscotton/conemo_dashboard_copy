# frozen_string_literal: true
# Hook into Call to Schedule Final Appointment lifecycle events.
class CallToScheduleFinalAppointmentObserver < ActiveRecord::Observer
  def after_save(scheduling_call)
    Tasks::FinalInPersonAppointment.create(
      participant: scheduling_call.participant,
      scheduled_at: scheduling_call.final_appointment_at
    )
  end

  def after_create(scheduling_call)
    Tasks::CallToScheduleFinalAppointment.active.find_by(
      participant: scheduling_call.participant
    ).try(:resolve)
  end
end
