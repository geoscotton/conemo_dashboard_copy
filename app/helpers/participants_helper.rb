# Helpers for Appointment/Contact based on participant status
module ParticipantsHelper
  def render_first_contact(participant)
    if participant.first_contact
      "#{participant.first_contact.contact_at}"
    else
      link_to "", new_participant_first_contact_path(participant),
              class: "fa fa-plus-circle fa-2x",
              id: "first_contact_#{participant.id}"
    end
  end
end