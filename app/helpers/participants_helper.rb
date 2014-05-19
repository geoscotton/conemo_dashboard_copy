# Helpers for Appointment/Contact based on participant status
module ParticipantsHelper
  def first_contact(participant)
    if participant.first_contact
      "#{l participant.first_contact.contact_at, format: :long}"
    else
      link_to " #{t 'conemo.views.shared.create'}", new_participant_first_contact_path(participant),
              class: "fa fa-plus-circle",
              id: "first_contact_#{participant.id}"
    end
  end

  def first_appointment(participant)
    if participant.first_appointment
      "#{l participant.first_appointment.appointment_at, format: :long}"
    elsif participant.first_contact
      if participant.first_contact.first_appointment_at > DateTime.current
        link_to " #{l participant.first_contact.first_appointment_at, format: :long}
         / #{participant.first_contact.first_appointment_location}",
                new_participant_first_appointment_path(participant),
                class: "fa fa-plus-circle", id: "appointment_#{participant.id}"
      else
        link_to " #{t 'conemo.views.active.participants.index.missed_appointment'}", missed_appointment_path(participant_id: participant.id, id: participant.first_contact.id), class: "fa fa-edit"
      end
    else
      ""
    end
  end

  def second_contact(participant)
    if participant.second_contact
      "#{l participant.second_contact.contact_at, format: :long}"
    elsif participant.first_appointment
      if participant.first_appointment.next_contact > DateTime.current
        link_to " #{l participant.first_appointment.next_contact, format: :long}",
                new_participant_second_contact_path(participant),
                class: "fa fa-plus-circle",
                id: "second_contact_#{participant.id}"
      else
        link_to " #{t 'conemo.views.active.participants.index.missed_appointment'}", missed_second_contact_path(participant_id: participant.id, id: participant.first_appointment.id), class: "fa fa-edit"
      end
    else
      ""
    end
  end

  def render_status_link(participant)
    if participant.help_messages.exists?(read: false)
      blink = "blink-me"
    else
      blink = ""
    end
    link_to "#{fa_icon 'circle 2x'}".html_safe,
            active_report_path(participant),
            class: "#{study_status(participant)} #{blink}"
  end

  def render_large_status(participant)
    "<i class='fa fa-circle #{study_status(participant)}'></i>".html_safe
  end

  def study_status(participant)
    case participant.current_study_status
    when "stable"
      "green"
    when "warning"
      "yellow"
    when "danger"
      "red"
    else
      "disabled"
    end
  end
end