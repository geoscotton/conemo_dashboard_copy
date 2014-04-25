# Information gathered by phone after First Appointment
class SecondContact < ActiveRecord::Base
  belongs_to :participant
  has_one :nurse_participant_evaluation, dependent: :destroy

  validates :participant,
            :contact_at,
            :session_length,
            presence: true
end
