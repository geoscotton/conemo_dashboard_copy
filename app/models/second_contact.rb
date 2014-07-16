# Information gathered by phone after First Appointment
class SecondContact < ActiveRecord::Base
  include MessageScheduler

  model_name.instance_variable_set :@route_key, "second_contact"

  belongs_to :participant
  has_one :nurse_participant_evaluation, dependent: :destroy
  has_many :patient_contacts

  accepts_nested_attributes_for :nurse_participant_evaluation
  accepts_nested_attributes_for :patient_contacts

  validates :participant,
            :contact_at,
            :session_length,
            :next_contact,
            presence: true
end
