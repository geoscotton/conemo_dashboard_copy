# Initial phone contact information for Participant
class FirstContact < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "first_contact"
  belongs_to :participant

  validates :participant,
            :contact_at,
            :first_appointment_at,
            :first_appointment_location,
            presence: true

  def schedule_message_24_hours(locale)
    ReminderMessage.create!(participant_id: participant.id, nurse_id: participant.nurse.id, locale: locale, notify_at: first_appointment_at - 1.day, type: "first-appointment-24")
  end

  def schedule_message_1_hour(locale)
    ReminderMessage.create!(participant_id: participant.id, nurse_id: participant.nurse.id, locale: locale, notify_at: first_appointment_at - 1.hour, type: "first-appointment-1")
  end
end
