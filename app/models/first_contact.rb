# Initial phone contact information for Participant
class FirstContact < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "first_contact"
  belongs_to :participant

  validates :participant,
            :contact_at,
            :first_appointment_at,
            :first_appointment_location,
            presence: true

  def schedule_message(locale)
    schedule_24_hour(locale)
    schedule_1_hour(locale)
  end

  def schedule_24_hour(locale)
    ReminderMessage.create!(participant_id: participant.id,
                            nurse_id: participant.nurse.id,
                            locale: locale,
                            notify_at: first_appointment_at - 1.day,
                            message_type: "first-appointment-24"
                            )
  end

  def schedule_1_hour(locale)
    ReminderMessage.create!(participant_id: participant.id,
                            nurse_id: participant.nurse.id,
                            locale: locale,
                            notify_at: first_appointment_at - 1.hour,
                            message_type: "first-appointment-1"
                            )
  end
end
