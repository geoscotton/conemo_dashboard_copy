# Nurse evaluation of Participant for First Appointment
class NurseParticipantEvaluation < ActiveRecord::Base
  belongs_to :third_contact
  belongs_to :second_contact

  validates :q1,
            :q2,
            presence: true
end
