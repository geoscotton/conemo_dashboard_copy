module Active
  # Managing Active Participants
  class ParticipantsController < ApplicationController
    def index
      @participants = Participant.active.where(locale: params[:locale])
    end

    def show
      @participant = Participant.find(params[:id])
    end

    def report
      @participant = Participant.find(params[:id])
      @lessons = Lesson.order("day_in_treatment ASC")
    end
  end
end
