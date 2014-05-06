module Active
  # Managing Active Participants
  class ParticipantsController < ApplicationController
    def index
      @participants = Participant.active
    end

    def show
      @participant = Participant.find(params[:id])
    end

    def report
      @participant = Participant.find(params[:id])
      @lessons = Lesson.order("day_in_treatment DESC")
    end
  end
end
