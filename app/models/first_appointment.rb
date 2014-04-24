# In-Person Participant Appointment record for Participant
class FirstAppointment < ActiveRecord::Base
  belongs_to :participant, dependent: :destroy
  has_one :nurse_participant_evaluation

  validates :participant_id,
            :appointment_at,
            :appointment_location,
            :session_length,
            :next_contact,
            presence: true
end
