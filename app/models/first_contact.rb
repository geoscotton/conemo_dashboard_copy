# Initial phone contact information for Participant
class FirstContact < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, 'first_contact'
  belongs_to :participant

  validates :participant,
            :contact_at,
            :first_appointment_at,
            :first_appointment_location,
            presence: true
end
