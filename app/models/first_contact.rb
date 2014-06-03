# Initial phone contact information for Participant
class FirstContact < ActiveRecord::Base
  include MessageScheduler

  model_name.instance_variable_set :@route_key, "first_contact"
  belongs_to :participant
  has_many :patient_contacts
  accepts_nested_attributes_for :patient_contacts


  validates :participant,
            :contact_at,
            :first_appointment_at,
            :first_appointment_location,
            presence: true
end