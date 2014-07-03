# Nurse evaluation of Participant for First Appointment
class NurseParticipantEvaluation < ActiveRecord::Base
  belongs_to :first_appointment
  belongs_to :second_contact

  validates :smartphone_comfort,
            :participant_session_engagement,
            :app_usage_prediction,
            presence: true
end
