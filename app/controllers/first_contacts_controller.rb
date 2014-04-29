# Handles First Contact info creation for active participant
class FirstContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @first_contact = participant.build_first_contact
  end

  def create
  end

  private

  def participant
    participant = Participant.find(params[:participant_id])
  end
  helper_method :participant

  def record_not_found
    redirect_to active_participants_url, alert: "Participant not found"
  end
end