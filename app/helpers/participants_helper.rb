# Helpers for Appointment/Contact based on participant status
module ParticipantsHelper
  def render_first_contact(participant)
    if participant.first_contact
      "#{participant.first_contact.contact_at.to_s(:long)}"
    else
      link_to " create", new_participant_first_contact_path(participant),
              class: "fa fa-plus-circle",
              id: "first_contact_#{participant.id}"
    end
  end

  def render_first_appointment(participant)
    if participant.first_appointment
      "#{participant.first_appointment.appointment_at.to_s(:long)}"
    elsif participant.first_contact
      link_to " #{participant.first_contact.first_appointment_at.to_s(:long)}",
              new_participant_first_appointment_path(participant),
              class: "fa fa-plus-circle",
              id: "first_appointment_#{participant.id}"
    else
      ""
    end
  end

  def render_second_contact(participant)
    if participant.second_contact
      "#{participant.second_contact.contact_at.to_s(:long)}"
    elsif participant.first_appointment
      link_to " #{participant.first_appointment.next_contact.to_s(:long)}",
              new_participant_second_contact_path(participant),
              class: "fa fa-plus-circle",
              id: "second_contact_#{participant.id}"
    else
      ""
    end
  end
end