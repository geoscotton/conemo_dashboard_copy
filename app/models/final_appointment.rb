# frozen_string_literal: true
# Represents the final meeting of a Nurse with a Participant.
class FinalAppointment < ActiveRecord::Base
  belongs_to :participant
  model_name.instance_variable_set :@route_key, "final_appointment"

  validates :participant,
            :appointment_at,
            :appointment_location,
            presence: true
  validates :phone_returned, inclusion: { in: [true, false] }

  after_initialize :populate_timestamps

  private

  def default_appointment_at
    Tasks::FinalInPersonAppointment.find_by(participant: participant)
                                   .try(:scheduled_at) || Time.zone.now
  end

  def populate_timestamps
    self.appointment_at ||= default_appointment_at
  end
end
