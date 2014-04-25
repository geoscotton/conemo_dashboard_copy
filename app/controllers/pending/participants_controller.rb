module Pending
  # Managing pending participants.
  class ParticipantsController < ApplicationController
    def index
    end

    def show
    end

    private

    def pending_participants
      Participant.pending
    end
    helper_method :pending_participants
  end
end