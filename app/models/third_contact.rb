# Represents the third meeting of the Nurse with the Participant.
class ThirdContact < ActiveRecord::Base
  include MessageScheduler

  model_name.instance_variable_set :@route_key, "third_contact"

  belongs_to :participant
  has_many :patient_contacts
  has_one :nurse_participant_evaluation, dependent: :destroy

  accepts_nested_attributes_for :patient_contacts
  accepts_nested_attributes_for :nurse_participant_evaluation

  validates :participant,
            :contact_at,
            :session_length,
            :call_to_schedule_final_appointment_at,
            presence: true
end
