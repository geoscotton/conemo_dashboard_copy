# In-Person Participant Appointment record for Participant
class FirstAppointment < ActiveRecord::Base
  model_name.instance_variable_set :@route_key, "first_appointment"
  belongs_to :participant
  has_one :nurse_participant_evaluation, dependent: :destroy
  accepts_nested_attributes_for :nurse_participant_evaluation

  validates :participant,
            :appointment_at,
            :appointment_location,
            :session_length,
            :next_contact,
            presence: true

  def schedule_message(locale)
    schedule_24_hour(locale)
    schedule_1_hour(locale)
  end

  def schedule_24_hour(locale)
    ReminderMessage.create!(participant_id: participant.id,
                            nurse_id: participant.nurse.id,
                            locale: locale,
                            notify_at: next_contact - 1.day,
                            message_type: "second-contact-24"
                            )
  end

  def schedule_1_hour(locale)
    ReminderMessage.create!(participant_id: participant.id,
                            nurse_id: participant.nurse.id,
                            locale: locale,
                            notify_at: next_contact - 1.hour,
                            message_type: "second-contact-1"
                            )
  end
end
