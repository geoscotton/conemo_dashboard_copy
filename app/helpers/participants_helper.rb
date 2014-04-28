module ParticipantsHelper
  def render_first_contact(participant)
    if participant.first_contact
      "#{participant.first_contact.contacted_at}"
    else
      link_to "", "#", class: "fa fa-plus-circle fa-2x"
    end    
  end
end