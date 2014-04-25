module Pending
  # Managing pending participants.
  class ParticipantsController < ApplicationController
    def index
      @participants = Participant.pending
    end

    def show
      @participant = Participant.where(id: params[:id])
    end
  end
end