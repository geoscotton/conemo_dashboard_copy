module Active
  # Managing Active Participants
  class ParticipantsController < ApplicationController
    def index
      @participants = Participant.active
    end

    def show
      @participant = Participant.find(params[:id])
    end
  end
end
