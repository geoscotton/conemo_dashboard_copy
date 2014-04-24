# Nurse evaluation of Participant for First Appointment and Second Contact
class NurseParticipantEvaluation < ActiveRecord::Base
  belongs_to :first_appointment, dependent: :destroy
  belongs_to :second_contact, dependent: :destroy

  validates :smartphone_comfort,
            :participant_session_engagement,
            :app_usage_prediction,
            presence: true
end
