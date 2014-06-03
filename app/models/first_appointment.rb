# In-Person Participant Appointment record for Participant
class FirstAppointment < ActiveRecord::Base
  include MessageScheduler

  model_name.instance_variable_set :@route_key, "first_appointment"
  belongs_to :participant
  has_one :nurse_participant_evaluation, dependent: :destroy
  has_many :patient_contacts
  accepts_nested_attributes_for :nurse_participant_evaluation
  accepts_nested_attributes_for :patient_contacts

  validates :participant,
            :appointment_at,
            :appointment_location,
            :session_length,
            :next_contact,
            presence: true
end