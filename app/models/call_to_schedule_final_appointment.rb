# Captures information from call by Nurse to Participant.
class CallToScheduleFinalAppointment < ActiveRecord::Base
  belongs_to :participant

  validates :participant, :contact_at, :final_appointment_at,
            :final_appointment_location, presence: true

  after_initialize :set_contact_at

  def self.build_for_participant(participant, params = {})
    new(params.merge(participant: participant))
  end

  private

  def set_contact_at
    self.contact_at ||= participant
                        .third_contact
                        .try(:call_to_schedule_final_appointment_at)
  end
end
