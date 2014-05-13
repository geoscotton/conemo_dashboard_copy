# SMS message sent for appointment reminders
class ReminderMessage < ActiveRecord::Base
  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  belongs_to :participant

  validates :nurse,
            :participant,
            presence: true

  MESSAGE_TYPES = { nurse: 'nurse', participant: 'participant' }

  MESSAGES = {
    pt_BR: {
      participant: {
        contact: {
          hour_1: "Portuguese 1 hour participant reminder for first appointment",
          hour_24: "Você terá seu primeiro encontro sobre o CONEMO com o técnico(a) de enfermagem AMANHÃ. Por favor, entre em contato com ele(a) caso você precise reagendar o encontro."
        },
        appointment: {
          hour_1: "Portuguese 1 hour participant reminder for second conctact",
          hour_24: "Você terá seu primeiro encontro sobre o CONEMO com o técnico(a) de enfermagem AMANHÃ. Por favor, entre em contato com ele(a) caso você precise reagendar o encontro."
        }
      },
      nurse: {
        contact: {
          hour_1: "Portuguese 1 hour nurse reminder for first appointment",
          hour_24: "Você terá seu primeiro encontro sobre o CONEMO com o técnico(a) de enfermagem AMANHÃ. Por favor, entre em contato com ele(a) caso você precise reagendar o encontro."
        },
        appointment: {
          hour_1: "Portuguese 1 hour nurse reminder for second conctact",
          hour_24: "Você terá seu primeiro encontro sobre o CONEMO com o técnico(a) de enfermagem AMANHÃ. Por favor, entre em contato com ele(a) caso você precise reagendar o encontro."
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
        }
      },
      nurse: {
        contact: {
          hour_1: "English 1 hour nurse reminder for first appointment",
          hour_24: "English 24 hour participant reminder for first appointment."
        },
        appointment: {
          hour_1: "English 1 hour nurse reminder for second conctact",
          hour_24: "English 24 hour nurse reminder for second conctact"
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
        }
      }
    }
  }

  def notification_time
    if appointment_type == "First contact"
      if notify_at == "1"
        participant.first_contact.first_appointment_at - 1.hour
      else
        participant.first_contact.first_appointment_at - 1.day
      end
    else
      if notify_at == "1"
        participant.first_appointment.next_contact - 1.hour
      else
        participant.first_appointment.next_contact - 1.day
      end
    end
  end

  def message
    string_locale = participant.locale.gsub '-', '_'
    MESSAGES[string_locale.to_sym][message_type.to_sym][appointment_type.split(" ").last.to_sym]["hour_#{notify_at}".to_sym]
  end
end