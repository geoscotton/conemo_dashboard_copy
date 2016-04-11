# frozen_string_literal: true
# Information gathered by phone after First Appointment
class SecondContact < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "second_contact"

  THIRD_CONTACT_ABSOLUTE_DELAY = 3.weeks
  THIRD_CONTACT_RELATIVE_DELAY = 2.weeks

  belongs_to :participant
  has_many :patient_contacts

  accepts_nested_attributes_for :patient_contacts

  serialize :difficulties

  validates :participant,
            :contact_at,
            :session_length,
            :next_contact,
            presence: true

  after_initialize :populate_timestamps

  private

  def default_contact_at
    Tasks::FollowUpCallWeekOne.find_by(participant: participant)
                              .try(:scheduled_at) || Time.zone.now
  end

  def default_next_contact_at
    first_appointment_at = participant.try(:first_appointment).try(:appointment_at)

    if first_appointment_at
      first_appointment_at + THIRD_CONTACT_ABSOLUTE_DELAY
    else
      Time.zone.now + THIRD_CONTACT_RELATIVE_DELAY
    end
  end

  def populate_timestamps
    self.contact_at ||= default_contact_at
    self.next_contact ||= default_next_contact_at
  end
end
