# frozen_string_literal: true
module Active
  # Managing Active Participants
  class ParticipantsController < ApplicationController
    helper do
      def token_for(participant)
        TokenAuth::ConfigurationToken
          .find_by(entity_id: participant.id)
          .try(:value)
      end
    end

    def show
      @participant = Participant.find(params[:id])
      authorize! :read, @participant
    end

    def report
      @participant = Participant.find(params[:id])
      authorize! :read, @participant
      @lessons = Lesson.where(locale: I18n.locale).order(day_in_treatment: :asc)
    end
  end
end
