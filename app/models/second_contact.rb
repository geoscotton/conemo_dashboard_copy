# Information gathered by phone after First Appointment
class SecondContact < ActiveRecord::Base
  belongs_to :participant, dependent: :destroy
  has_one :nurse_participant_evaluation

  validates :participant_id,
            :contact_at,
            :session_length,
            presence: true
end
