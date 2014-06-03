# Schedules reminder messages for First Appointment, Second Contact, and Final appointment
module MessageScheduler
  extend ActiveSupport::Concern

  def schedule_message(person, model_name_string)
    schedule_24_hour("nurse", model_name_string, person)
    schedule_24_hour("participant", model_name_string, person)
    schedule_1_hour("nurse", model_name_string, person)
    schedule_1_hour("participant", model_name_string, person)
  end

  def schedule_24_hour(message_type, model_name_string, person)
    ReminderMessage.create!(participant: person,
                            nurse: person.nurse,
                            notify_at: "24",
                            message_type: message_type,
                            appointment_type: model_name_string
                            )
  end

  def schedule_1_hour(message_type, model_name_string, person)
    ReminderMessage.create!(participant: person,
                            nurse: person.nurse,
                            notify_at: "1",
                            message_type: message_type,
                            appointment_type: model_name_string
                            )
  end
end