# In-Person Participant Appointment record for Participant
class FirstAppointment < ActiveRecord::Base
  belongs_to :participant
  has_one :nurse_participant_evaluation, dependent: :destroy

  validates :participant,
            :appointment_at,
            :appointment_location,
            :session_length,
            :next_contact,
            presence: true
end
