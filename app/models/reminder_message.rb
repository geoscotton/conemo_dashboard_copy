# SMS message sent for appointment reminders
class ReminderMessage < ActiveRecord::Base
  belongs_to :nurse, class_name: "User", foreign_key: :nurse_id
  belongs_to :participant

  validates :nurse,
            :participant,
            presence: true

  MESSAGES = {
    pt_part_first_24: "Você terá seu primeiro encontro sobre o CONEMO com o técnico(a) de enfermagem AMANHÃ. Por favor, entre em contato com ele(a) caso você precise reagendar o encontro.",
    pt_nurse_first_24: "Você terá seu primeiro encontro sobre o CONEMO com seu paciente AMANHÃ. Por favor, entre em contato com ele(a) caso você precise reagendar o encontro.",
    en_part_first_24: "You have your first CONEMO appointment with the nurse assistant tomorrow. Please, let us know if you need to reschedule."
  }
end
