module Active
  # Managing Active Participants
  class ParticipantsController < ApplicationController
    def index
      @participants = Participant.active.where(locale_param).order(created_at: :desc)
    end

    def show
      @participant = Participant.find(params[:id])
    end

    def report
      @participant = Participant.find(params[:id])
      @lessons = Lesson.where(locale_param).order(day_in_treatment: :asc)
      @dialogues = Dialogue.where(locale_param).order(day_in_treatment: :asc)
    end

    private

    def locale_param
      params.permit :locale
    end
  end
end
