module Pending
  # Managing pending participants.
  class ParticipantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      @pending_participants = Participant.pending.where(locale: params[:locale])
      authorize! :read, @pending_participants
      
      @ineligible_participants = Participant.ineligible
                                            .where(locale: params[:locale])
      authorize! :read, @ineligible_participants
    end

    def activate
      @participant = Participant.find(params[:id])
      authorize! :read, @participant
      @nurses = User.where(role: "nurse", locale: params[:locale])
    end

    private

    def record_not_found
      redirect_to pending_participants_url, alert: "Participant not found"
    end
  end
end
