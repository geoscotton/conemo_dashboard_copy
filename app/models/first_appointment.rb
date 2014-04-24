class FirstAppointment < ActiveRecord::Base
  belongs_to :participant, dependent: :destroy

  validates :participant_id,
            :appointment_at,
            :appointment_location,
            :session_length, null: false
      t.datetime :next_contact, null: false
end
