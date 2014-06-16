class ThirdContact < ActiveRecord::Base
  include MessageScheduler
  
  model_name.instance_variable_set :@route_key, "third_contact"
  
  belongs_to :participant
  has_many :patient_contacts
  
  accepts_nested_attributes_for :patient_contacts

  validates :participant,
            :contacted_at,
            :session_length,
            :final_appointment_at,
            :final_appointment_location,
            presence: true
end
