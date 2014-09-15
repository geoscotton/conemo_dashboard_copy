# SMS message sent for appointment reminders
class ReminderMessage < ActiveRecord::Base
  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  belongs_to :participant

  validates :nurse,
            :participant,
            presence: true

  APPOINTMENT_TYPES = ["third_contact", "second_contact", "appointment", "final"]
  MESSAGE_TYPES = {nurse: "nurse", participant: "participant"}

  validates :appointment_type, inclusion: {in: APPOINTMENT_TYPES}

  MESSAGES = {
      pt_BR: {
          participant: {
              appointment: {
                  hour_1: "Seu primeiro encontro CONEMO  é em uma hora.",
                  hour_24: { 
                    part_a: "Seu primeiro encontro CONEMO com a enfermagem é AMANHÃ.",
                    part_b: "Para reagendar, entre em contato."
                  }
              },
              second_contact: {
                  hour_1: "O técnico de enfermagem irá lhe telefonar nas 1 hora",
                  hour_24: "O(a) técnico(a) de enfermagem irá lhe telefonar nas próximas 24 horas."
              },
              third_contact: {
                  hour_1: "O técnico de enfermagem irá lhe telefonar em 1 hora",
                  hour_24: "O(a) técnico(a) de enfermagem irá lhe telefonar nas próximas 24 horas."
              },
              final: {
                  hour_1: "Sua consulta final do CONEMO é em uma hora",
                  hour_24: {
                    part_a: "Sua consulta final do CONEMO é AMANHÃ.",
                    part_b: "Para reagendar, entre em contato."
                  }
              }
          },
          nurse: {
              appointment: {
                  hour_1: "Primeiro contato com novo paciente em uma hora",
                  hour_24: {
                    part_a: "Primeiro contato com novo paciente amanhã.",
                    part_b: "Para reagendar, entre em contato."
                  }
              },
              second_contact: {
                  hour_1: "Não se esqueça de telefonar para seu paciente em 1 hora",
                  hour_24: "Não esqueça de telefonar para seu paciente dentro de 24 horas"
              },
              third_contact: {
                  hour_1: "Não se esqueça de telefonar para seu paciente em 1 hora",
                  hour_24: "Não esqueça de telefonar para seu paciente dentro de 24 horas"
              },
              final: {
                  hour_1: "Você tem paciente para última consulta em uma hora",
                  hour_24: {
                    part_a: "Você tem paciente para última consulta AMANHÃ.",
                    part_b: "Para reagendar, entre em contato."
                  }
              }
          }
      },
      en: {
          participant: {
              appointment: {
                  hour_1: "You have your first CONEMO appointment with the nurse assistant in 1 hour.",
                  hour_24: "You have your first CONEMO appointment with the nurse assistant tomorrow. Please, let us know if you need to reschedule."
              },
              second_contact: {
                  hour_1: "Your nurse assistant will call you in 1 hour",
                  hour_24: "Your nurse assistant will call you in the next 24 hours"
              },
              third_contact: {
                  hour_1: "Your nurse assistant will call you in 1 hour",
                  hour_24: "Your nurse assistant will call you in the next 24 hours"
              },
              final: {
                  hour_1: "English 1 hour participant reminder for final appointment",
                  hour_24: "English 24 hour participant reminder for final appointment"
              }
          },
          nurse: {
              appointment: {
                  hour_1: "You have your first CONEMO appointment with a patient in 1 hour",
                  hour_24: "You have your first CONEMO appointment with a patient tomorrow. Please, contact him/her if you need to reschedule."
              },
              second_contact: {
                  hour_1: "Don’t forget to call your patient in the next hour",
                  hour_24: "Don’t forget to call your patient in the next 24 hours"
              },
              third_contact: {
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
              appointment: {
                  hour_1: "Su cita en el programa CONEMO empieza en una hora",
                  hour_24: "Acuerdese de su cita maniana en el CEDHI para iniciar el programa CONEMO."
              },
              second_contact: {
                  hour_1: "Tu enfermera o enfermero te llamara en 1 hora.",
                  hour_24: "Su enfermera o enfermero de CONEMO te llamara en las proximas 24 horas."
              },
              third_contact: {
                  hour_1: "Tu enfermera o enfermero te llamara en 1 hora.",
                  hour_24: "Su enfermera o enfermero de CONEMO te llamara en las proximas 24 horas."
              },
              final: {
                  hour_1: "Su cita final dentro del programa CONEMO empieza en una hora",
                  hour_24: "Acuerdese de su cita maniana en el CEDHI para finalizar el programa CONEMO."
              }
          },
          nurse: {
              appointment: {
                  hour_1: "Tu cita con un nuevo paciente del programa CONEMO empieza en una hora",
                  hour_24: "Maniana tienes la primera cita con un nuevo paciente del programa CONEMO."
              },
              second_contact: {
                  hour_1: "Recuerda llamar a tu paciente en 1 hora",
                  hour_24: "Recuerda llamar a tu paciente en las proximas 24 horas"
              },
              third_contact: {
                  hour_1: "Recuerda llamar a tu paciente en 1 hora",
                  hour_24: "Recuerda llamar a tu paciente en las proximas 24 horas"
              },
              final: {
                  hour_1: "Tu cita final con un paciente del programa CONEMO empieza en una hora",
                  hour_24: "Maniana tienes la cita final con un paciente del programa CONEMO"
              }
          }
      }
  }

  # returns datetime object for the reminder message
  def notification_time
    if appointment_type == "appointment"
      if notify_at == "1"
        participant.first_contact.first_appointment_at - 1.hour
      else # => '24'
        participant.first_contact.first_appointment_at - 1.days
      end
    elsif appointment_type == "second_contact"
      if notify_at == "1"
        participant.first_appointment.next_contact - 1.hour
      else
        participant.first_appointment.next_contact - 1.days
      end
    elsif appointment_type == "third_contact"
      if notify_at == "1"
        participant.second_contact.next_contact - 1.hour
      else
        participant.second_contact.next_contact - 1.days
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
  def message(message_part=nil)
    string_locale = participant.locale.gsub("-", "_").to_sym
    hour = "hour_#{notify_at}".to_sym
    appointment = appointment_type.to_sym
    
    if split_message && message_part
      MESSAGES[string_locale][message_type.to_sym][appointment][hour][message_part.to_sym] + set_identifier
    else
      MESSAGES[string_locale][message_type.to_sym][appointment][hour] + set_identifier
    end
  end

  def set_identifier
    if message_type == "nurse"
      return " -- #{participant.study_identifier}"
    else
      return ""
    end
  end

  # determines if a message has been split into two parts
  def split_message
    if participant.locale == "pt-BR" && (appointment_type == "appointment" || appointment_type == "final")
      return true
    else
      return false
    end
  end

  # requeues sent message if appointment time has been updated
  def requeue
    if status == "sent"
      update_attribute(:status, "pending")
    end
  end
end
