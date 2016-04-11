# frozen_string_literal: true
# Manages Supervisor Notes for active Participants.
class SupervisorNotesController < ApplicationController
  before_action :set_supervisor_note, only: [:edit, :update]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @supervisor_note = find_participant.supervisor_notes.build
    authorize! :create, @supervisor_note
  end

  def edit
    authorize! :update, @supervisor_note
  end

  def create
    @supervisor_note = find_participant
                       .supervisor_notes
                       .build(supervisor_note_params)
    authorize! :create, @supervisor_note

    if @supervisor_note.save
      redirect_to active_report_url(@participant),
                  notice: "Supervisor note was successfully created."
    else
      render :new
    end
  end

  def update
    authorize! :update, @supervisor_note

    if @supervisor_note.update(supervisor_note_params)
      redirect_to active_report_url(@participant),
                  notice: "Supervisor note was successfully updated."
    else
      render :edit
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_supervisor_note
    @supervisor_note = find_participant.supervisor_notes.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def supervisor_note_params
    params.require(:supervisor_note).permit(:note)
  end

  def find_participant
    @participant ||= Participant.find(params[:participant_id])
  end
end
