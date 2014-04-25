# Initial phone contact information for Participant
class FirstContact < ActiveRecord::Base
  belongs_to :participant

  validates :participant,
            :contact_at,
            :first_appointment_at,
            :first_appointment_location,
            presence: true
end
