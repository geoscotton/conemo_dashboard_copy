# Helpers for Appointment/Contact based on participant status
module ParticipantsHelper
  def first_contact(participant)
    if participant.first_contact
      "#{l participant.first_contact.contact_at, format: :long}"
    else
      link_to " create", new_participant_first_contact_path(participant),
              class: "fa fa-plus-circle",
              id: "first_contact_#{participant.id}"
    end
  end

  def first_appointment(participant)
    if participant.first_appointment
      "#{l participant.first_appointment.appointment_at, format: :long}"
    elsif participant.first_contact
      link_to " #{l participant.first_contact.first_appointment_at, format: :long}
       / #{participant.first_contact.first_appointment_location}",
              new_participant_first_appointment_path(participant),
              class: "fa fa-plus-circle", id: "appointment_#{participant.id}"
    else
      ""
    end
  end

  def second_contact(participant)
    if participant.second_contact
      "#{l participant.second_contact.contact_at, format: :long}"
    elsif participant.first_appointment
      link_to " #{l participant.first_appointment.next_contact, format: :long}",
              new_participant_second_contact_path(participant),
              class: "fa fa-plus-circle",
              id: "second_contact_#{participant.id}"
    else
      ""
    end
  end

  def study_status(participant)
    if participant.content_access_events.any?
      link_to "#{fa_icon 'circle 2x'}".html_safe, active_report_path(participant)
    else
      fa_icon "circle 2x disabled"
    end
  end
end