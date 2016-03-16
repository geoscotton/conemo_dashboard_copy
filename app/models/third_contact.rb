# frozen_string_literal: true
# Represents the third meeting of the Nurse with the Participant.
class ThirdContact < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "third_contact"

  FINAL_CALL_ABSOLUTE_DELAY = 6.weeks
  FINAL_CALL_RELATIVE_DELAY = 3.weeks

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

  after_initialize :populate_timestamps

  private

  def default_contact_at
    Tasks::FollowUpCallWeekThree.find_by(participant: participant)
                                .try(:scheduled_at) || Time.zone.now
  end

  def default_next_contact_at
    first_appointment_at = participant.first_appointment.try(:appointment_at)

    if first_appointment_at
      first_appointment_at + FINAL_CALL_ABSOLUTE_DELAY
    else
      Time.zone.now + FINAL_CALL_RELATIVE_DELAY
    end
  end

  def populate_timestamps
    self.contact_at ||= default_contact_at
    self.call_to_schedule_final_appointment_at ||= default_next_contact_at
  end
end
