class FirstContact < ActiveRecord::Base
  belongs_to :participant, dependent: :destroy

  validates :participant_id,
            :contact_at,
            :first_appointment_at,
            :first_appointment_location,
            presence: true
end
