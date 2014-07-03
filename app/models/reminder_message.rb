# SMS message sent for appointment reminders
class ReminderMessage < ActiveRecord::Base
  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  belongs_to :participant

  validates :nurse,
            :participant,
            presence: true

  APPOINTMENT_TYPES = ["contact", "appointment", "final"]
  MESSAGE_TYPES = {nurse: "nurse", participant: "participant"}

  validates :appointment_type, inclusion: {in: APPOINTMENT_TYPES}

  MESSAGES = {
      pt_BR: {
          participant: {
              contact: {
                  hour_1: "Você terá seu primeiro encontro sobre o CONEMO com  o técnico(a) de enfermagem EM 1 HORA",
                  hour_24: "Você terá seu primeiro encontro sobre o CONEMO com o técnico(a) de enfermagem AMANHÃ. Por favor, entre em contato com ele(a) caso você precise reagendar o encontro"
              },
              appointment: {
                  hour_1: "O técnico de enfermagem irá lhe telefonar nas 1 hora",
                  hour_24: "O(a) técnico(a) de enfermagem irá lhe telefonar nas próximas 24 horas."
              },
              final: {
                  hour_1: "Portuguese 1 hour participant reminder for final appointment",
                  hour_24: "Portuguese 24 hour participant reminder for final appointment"
              }
          },
          nurse: {
              contact: {
                  hour_1: "Você terá seu primeiro encontro sobre o CONEMO com seu paciente EM 1 HORA.",
                  hour_24: "Você terá seu primeiro encontro sobre o CONEMO com seu paciente AMANHÃ. Por favor, entre em contato com ele(a) caso você precise reagendar o encontro"
              },
              appointment: {
                  hour_1: "Portuguese 1 hour nurse reminder for second conctact",
                  hour_24: "Não esqueça de telefonar para seu paciente dentro de 24 horas"
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
                  hour_1: "You have your first CONEMO appointment with the nurse assistant in 1 hour.",
                  hour_24: "You have your first CONEMO appointment with the nurse assistant tomorrow. Please, let us know if you need to reschedule."
              },
              appointment: {
                  hour_1: "Your nurse assistant will call you in 1 hour",
                  hour_24: "Your nurse assistant will call you in the next 24 hours"
              },
              final: {
                  hour_1: "English 1 hour participant reminder for final appointment",
                  hour_24: "English 24 hour participant reminder for final appointment"
              }
          },
          nurse: {
              contact: {
                  hour_1: "You have your first CONEMO appointment with a patient in 1 hour",
                  hour_24: "You have your first CONEMO appointment with a patient tomorrow. Please, contact him/her if you need to reschedule."
              },
              appointment: {
                  hour_1: "Don’t forget to call your patient in the next hour",
                  hour_24: "Don’t forget to call your patient in the next 24 hours"
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
                  hour_1: "¡Tu cita en el programa CONEMO empieza en una hora",
                  hour_24: "Mañana tienes una cita con una enfermera del CEDHI para comenzar con el programa CONEMO. Si necesitas cambiarla, por favor, llama a uno de los números entregados"
              },
              appointment: {
                  hour_1: "Tu enfermera o enfermero te llamará en 1 hora.",
                  hour_24: "Tu enfermera o enfermero te llamará en las próximas 24 horas."
              },
              final: {
                  hour_1: "¡Tu cita final dentro del programa CONEMO empieza en una hora!",
                  hour_24: "Mañana tienes una cita con una enfermera del CEDHI para finalizar el programa CONEMO. Si necesitas cambiarla, por favor, llama a uno de los números entregados."
              }
          },
          nurse: {
              contact: {
                  hour_1: "¡Tu primera cita con uno de los pacientes del programa CONEMO empieza en una hora!",
                  hour_24: "Mañana tienes la primera cita con un nuevo paciente del programa CONEMO. Si necesitas cambiarla, por favor, llama al paciente y regístralo en la web"
              },
              appointment: {
                  hour_1: "Recuerda llamar a tu paciente en 1 hora",
                  hour_24: "Recuerda llamar a tu paciente en las próximas 24 horas"
              },
              final: {
                  hour_1: "¡Tu cita final con uno de los pacientes del programa CONEMO empieza en una hora!",
                  hour_24: "Mañana tienes la cita final con un paciente del programa CONEMO. Si necesitas cambiarla, por favor, llama al paciente y regístralo en la web."
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
        participant.first_contact.first_appointment_at - 1.days
      end
    elsif appointment_type == "appointment"
      if notify_at == "1"
        participant.first_appointment.next_contact - 1.hour
      else
        participant.first_appointment.next_contact - 1.days
      end
    else # => 'final'
      if notify_at == "1"
        participant.third_contact.final_appointment_at - 1.hour
      else
        participant.third_contact.final_appointment_at - 1.days
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