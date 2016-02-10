module Active
  # Managing Active Participants
  class ParticipantsController < ApplicationController
    def index
      @participants = if current_user.admin?
                        Participant.where(locale: I18n.locale)
                                   .active
                                   .order(created_at: :desc)
                      else
                        current_user.active_participants
                                    .order(created_at: :desc)
                      end
      authorize! :read, @participants
    end

    def show
      @participant = Participant.find(params[:id])
      authorize! :read, @participant
    end

    def report
      @participant = Participant.find(params[:id])
      authorize! :read, @participant
      @lessons = Lesson.where(locale: I18n.locale).order(day_in_treatment: :asc)
      @dialogues = Dialogue.where(locale: I18n.locale)
                           .order(day_in_treatment: :asc)
    end
  end
end
