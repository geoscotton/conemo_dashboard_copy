class FirstAppointment < ActiveRecord::Base
  belongs_to :participant, dependent: :destroy

  validates :participant_id,
            :appointment_at,
            :appointment_location,
            :session_length,
            :next_contact,
            presence: true
end
