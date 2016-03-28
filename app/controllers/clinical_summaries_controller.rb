# frozen_string_literal: true
# Manage Participant clinical summaries.
class ClinicalSummariesController < ApplicationController
  def show
    @participant = Participant.find(params[:participant_id])
    authorize! :read, @participant
    @lessons = Lesson.where(locale: I18n.locale).order(day_in_treatment: :asc)
    @participant_contacts = ParticipantContactPresenter
                            .scheduled_contacts_for(@participant)
    render template: "active/participants/report"
  end
end
