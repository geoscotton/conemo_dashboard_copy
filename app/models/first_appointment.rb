# frozen_string_literal: true
# In-Person Participant Appointment record for Participant
class FirstAppointment < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "first_appointment"

  belongs_to :participant
  has_many :patient_contacts

  accepts_nested_attributes_for :patient_contacts

  validates :participant,
            :appointment_at,
            :session_length,
            presence: true

  after_initialize :populate_timestamps

  private

  def populate_timestamps
    default = Tasks::InitialInPersonAppointment
              .find_by(participant: participant)
              .try(:scheduled_at) || Time.zone.now

    self.appointment_at ||= default
  end
end
