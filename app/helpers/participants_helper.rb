# Helpers for Appointment/Contact based on participant status
module ParticipantsHelper
  def first_contact(participant)
    if participant.first_contact
      fa_icon "check-circle 2x", style: "color: green"
    else
      link_to " #{t 'conemo.views.shared.create'}", new_participant_first_contact_path(participant),
              class: "fa fa-plus-circle table-link",
              id: "first_contact_#{participant.id}"
    end
  end

  def first_appointment(participant)
    if participant.first_appointment
      fa_icon "check-circle 2x", style: "color: green"
    elsif participant.first_contact
      " #{l participant.first_contact.first_appointment_at, format: :short} / #{participant.first_contact.first_appointment_location}"
    else
      ""
    end
  end

  def first_appointment_link(participant)
    if participant.first_appointment
      ""
    elsif participant.first_contact
      link_to " #{t 'conemo.views.shared.create'}",
              new_participant_first_appointment_path(participant),
              class: "fa fa-plus-circle table-link", id: "appointment_#{participant.id}"
    else
      ""
    end
  end

  def reschedule_first_appointment(participant)
    if participant.first_appointment
      ""
    elsif participant.first_contact
      link_to " #{t 'conemo.views.shared.reschedule'}",
            missed_appointment_path(participant_id: participant.id, id: participant.first_contact.id),
            class: "fa fa-edit reschedule-link"
    else
      ""
    end
  end

  def second_contact(participant)
    if participant.second_contact
      fa_icon "check-circle 2x", style: "color: green"
    elsif participant.first_appointment
      " #{l participant.first_appointment.next_contact, format: :long}"
    else
      ""
    end
  end

  def second_contact_link(participant)
    if participant.second_contact
      ""
    elsif participant.first_appointment
      link_to " #{t 'conemo.views.shared.create'}",
              new_participant_second_contact_path(participant),
              class: "fa fa-plus-circle table-link", id: "second_contact_#{participant.id}"
    else
      ""
    end
  end

  def reschedule_second_contact(participant)
    if participant.second_contact
      ""
    elsif participant.first_appointment
      link_to " #{t 'conemo.views.shared.reschedule'}",
            missed_second_contact_path(participant_id: participant.id, id: participant.first_appointment.id),
            class: "fa fa-edit reschedule-link"
    else
      ""
    end
  end

  def third_contact(participant)
    if participant.third_contact
      fa_icon "check-circle 2x", style: "color: green"
    elsif participant.second_contact
      " #{l participant.second_contact.contact_at + 3.weeks, format: :short}"
    else
      ""
    end
  end

  def third_contact_link(participant)
    if participant.third_contact
      ""
    elsif participant.second_contact
      link_to " #{t 'conemo.views.shared.create'}",
              new_participant_third_contact_path(participant),
              class: "fa fa-plus-circle table-link", id: "third_contact_#{participant.id}"
    else
      ""
    end
  end

  def final_appointment(participant)
    if participant.final_appointment
      fa_icon "check-circle 2x", style: "color: green;"
    elsif participant.third_contact
      " #{l participant.third_contact.final_appointment_at, format: :long}" rescue ''
    else
      ""
    end
  end

  def final_appointment_link(participant)
    if participant.final_appointment
      ""
    elsif participant.third_contact
      link_to " #{t 'conemo.views.shared.create'}",
              new_participant_final_appointment_path(participant),
              class: "fa fa-plus-circle table-link", id: "final_appointment_#{participant.id}"
    else
      ""
    end
  end

  def reschedule_final_appointment(participant)
    if participant.final_appointment
      ""
    elsif participant.third_contact
      link_to " #{t 'conemo.views.shared.reschedule'}",
            missed_final_appointment_path(participant_id: participant.id, id: participant.second_contact.id),
            class: "fa fa-edit reschedule-link"
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
    when "none"
      "none"
    else
      "disabled"
    end
  end
end