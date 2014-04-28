module Pending
  # Managing pending participants.
  class ParticipantsController < ApplicationController
    def index
      @participants = Participant.pending
    end

    def show
      @participant = Participant.where(id: params[:id]).first
    end

    def activate
      @participant = Participant.where(id: params[:id]).first
      @nurses = User.where(role: "nurse")
    end
  end
end