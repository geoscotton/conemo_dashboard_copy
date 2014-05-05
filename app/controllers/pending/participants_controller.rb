module Pending
  # Managing pending participants.
  class ParticipantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      @pending_participants = Participant.pending
      @ineligible_participants = Participant.ineligible
    end

    def activate
      @participant = Participant.find(params[:id])
      @nurses = User.where(role: "nurse")
    end

    private

    def record_not_found
      redirect_to pending_participants_url, alert: "Participant not found"
    end
  end
end