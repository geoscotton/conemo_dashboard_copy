# frozen_string_literal: true
# Nurse evaluation of Participant for First Appointment
class NurseParticipantEvaluation < ActiveRecord::Base
  belongs_to :third_contact
  belongs_to :second_contact

  has_one :third_contact_participant,
          through: :third_contact,
          class_name: "Participant",
          foreign_key: :participant_id,
          source: :participant

  has_one :second_contact_participant,
          through: :second_contact,
          class_name: "Participant",
          foreign_key: :participant_id,
          source: :participant

  validates :q1,
            :q2,
            presence: true
end
