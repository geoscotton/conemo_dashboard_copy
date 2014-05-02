# Information gathered by phone after First Appointment
class SecondContact < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "second_contact"
  belongs_to :participant
  has_one :nurse_participant_evaluation, dependent: :destroy
  accepts_nested_attributes_for :nurse_participant_evaluation

  validates :participant,
            :contact_at,
            :session_length,
            presence: true
end
