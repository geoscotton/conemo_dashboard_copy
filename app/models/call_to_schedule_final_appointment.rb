# frozen_string_literal: true
# Captures information from call by Nurse to Participant.
class CallToScheduleFinalAppointment < ActiveRecord::Base
  belongs_to :participant

  validates :participant, :contact_at, :final_appointment_at,
            :final_appointment_location, presence: true

  after_initialize :populate_timestamps

  def self.build_for_participant(participant, params = {})
    new(params.merge(participant: participant))
  end

  private

  def default_contact_at
    Tasks::CallToScheduleFinalAppointment.find_by(participant: participant)
                                         .try(:scheduled_at) || Time.zone.now
  end

  def populate_timestamps
    self.contact_at ||= default_contact_at
  end
end
