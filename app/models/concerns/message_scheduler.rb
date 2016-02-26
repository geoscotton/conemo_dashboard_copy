# frozen_string_literal: true
# Schedules reminder messages for First Appointment, Second Contact, and Final appointment
module MessageScheduler
  extend ActiveSupport::Concern

  def schedule_message(person, model_name_string)
    schedule_24_hour("nurse", model_name_string, person)
    schedule_24_hour("participant", model_name_string, person)
    schedule_1_hour("nurse", model_name_string, person)

    return unless model_name_string == "appointment" ||
                  model_name_string == "final"

    schedule_1_hour("participant", model_name_string, person)
  end

  def schedule_24_hour(message_type, model_name_string, person)
    message = ReminderMessage.find_or_initialize_by(participant: person,
                                                    nurse: person.nurse,
                                                    notify_at: "24",
                                                    message_type: message_type,
                                                    appointment_type: model_name_string
                                                   )

    message.requeue

    message.save
  end

  def schedule_1_hour(message_type, model_name_string, person)
    message = ReminderMessage.find_or_initialize_by(participant: person,
                                                    nurse: person.nurse,
                                                    notify_at: "1",
                                                    message_type: message_type,
                                                    appointment_type: model_name_string
                                                   )

    message.requeue

    message.save
  end
end
