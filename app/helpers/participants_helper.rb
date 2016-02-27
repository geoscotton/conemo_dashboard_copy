# frozen_string_literal: true
# Helpers for Appointment/Contact based on participant status
module ParticipantsHelper
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
