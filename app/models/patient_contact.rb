# Class for general patient notes
class PatientContact < ActiveRecord::Base
  belongs_to :participant
  belongs_to :first_contact
  belongs_to :first_appointment
  belongs_to :second_contact
  belongs_to :third_contact
end
