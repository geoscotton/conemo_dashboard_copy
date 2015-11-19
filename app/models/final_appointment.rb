# Represents the final meeting of a Nurse with a Participant.
class FinalAppointment < ActiveRecord::Base
  belongs_to :participant
  model_name.instance_variable_set :@route_key, "final_appointment"

  validates :participant,
            :appointment_at,
            :appointment_location,
            presence: true
  validates :phone_returned, inclusion: { in: [true, false] }
end
