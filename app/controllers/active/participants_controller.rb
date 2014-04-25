module Active
  # Managing Active Participants
  class ParticipantsController < ApplicationController
    def index
      @participants = Participant.pending
    end

    def show
      @participant = Participant.where(id: params[:id]).first
    end
  end
end