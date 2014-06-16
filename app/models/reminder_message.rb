# SMS message sent for appointment reminders
class ReminderMessage < ActiveRecord::Base
  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  belongs_to :participant

  validates :nurse,
            :participant,
            presence: true

  APPOINTMENT_TYPES = ["contact", "appointment", "final"]
  MESSAGE_TYPES = { nurse: "nurse", participant: "participant" }

  validates :appointment_type, inclusion: { in: APPOINTMENT_TYPES }

  MESSAGES = {
    pt_BR: {
      participant: {
        contact: {
          hour_1: "Portuguese 1 hour participant reminder for first appointment",
          hour_24: "Portuguese 24 hour participant reminder for first appointment"
        },
        appointment: {
          hour_1: "Portuguese 1 hour participant reminder for second conctact",
          hour_24: "Portuguese 24 hour participant reminder for second contact"
        },
        final: {
          hour_1: "Portuguese 1 hour participant reminder for final appointment",
          hour_24: "Portuguese 24 hour participant reminder for final appointment"
        }
      },
      nurse: {
        contact: {
          hour_1: "Portuguese 1 hour nurse reminder for first appointment",
          hour_24: "Portuguese 24 hour nurse reminder for first appointment"
        },
        appointment: {
          hour_1: "Portuguese 1 hour nurse reminder for second conctact",
          hour_24: "Portuguese 24 hour nurse reminder for second contact"
        },
        final: {
          hour_1: "Portuguese 1 hour nurse reminder for final appointment",
          hour_24: "Portuguese 24 hour nurse reminder for final appointment"
        }
      }
    },
    en: {
      participant: {
        contact: {
          hour_1: "English 1 hour participant reminder for first appointment",
          hour_24: "English 24 hour participant reminder for first appointment"
        },
        appointment: {
          hour_1: "English 1 hour participant reminder for second conctact",
          hour_24: "English 24 hour participant reminder for second contact"
        },
        final: {
          hour_1: "English 1 hour participant reminder for final appointment",
          hour_24: "English 24 hour participant reminder for final appointment"
        }
      },
      nurse: {
        contact: {
          hour_1: "English 1 hour nurse reminder for first appointment",
          hour_24: "English 24 hour nurse reminder for first appointment."
        },
        appointment: {
          hour_1: "English 1 hour nurse reminder for second conctact",
          hour_24: "English 24 hour nurse reminder for second conctact"
        },
        final: {
          hour_1: "English 1 hour nurse reminder for final appointment",
          hour_24: "English 24 hour nurse reminder for final appointment"
        }
      }
    },
    es_PE: {
      participant: {
        contact: {
          hour_1: "Spanish 1 hour participant reminder for first appointment",
          hour_24: "Spanish 24 hour participant reminder for first appointment"
        },
        appointment: {
          hour_1: "Spanish 1 hour participant reminder for second conctact",
          hour_24: "Spanish 24 hour participant reminder for second contact"
        },
        final: {
          hour_1: "Spanish 1 hour participant reminder for final appointment",
          hour_24: "Spanish 24 hour participant reminder for final appointment"
        }
      },
      nurse: {
        contact: {
          hour_1: "Spanish 1 hour nurse reminder for first appointment",
          hour_24: "Spanish 24 hour nurse reminder for first appointment"
        },
        appointment: {
          hour_1: "Spanish 1 hour nurse reminder for second conctact",
          hour_24: "Spanish 24 hour nurse reminder for second contact"
        },
        final: {
          hour_1: "Spanish 1 hour nurse reminder for final appointment",
          hour_24: "Spanish 24 hour nurse reminder for final appointment"
        }
      }
    }
  }

  # returns datetime object for the reminder message
  def notification_time
    if appointment_type == "contact"
      if notify_at == "1"
        participant.first_contact.first_appointment_at - 1.hour
      else # => '24'
        participant.first_contact.first_appointment_at - 1.day
      end
    elsif appointment_type == "appointment"
      if notify_at == "1"
        participant.first_appointment.next_contact - 1.hour
      else
        participant.first_appointment.next_contact - 1.day
      end
    else # => 'final'
      if notify_at == "1"
        participant.third_contact.final_appointment_at - 1.hour
      else
        participant.third_contact.final_appointment_at - 1.day
      end
    end
  end

  # message is constructed by traversing MESSAGES hash
  def message
    string_locale = participant.locale.gsub("-", "_").to_sym
    hour = "hour_#{notify_at}".to_sym
    appointment = appointment_type.to_sym
    MESSAGES[string_locale][message_type.to_sym][appointment][hour]
  end
end