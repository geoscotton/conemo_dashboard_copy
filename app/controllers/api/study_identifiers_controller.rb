# frozen_string_literal: true
module Api
  # JSON respond with study identifier.
  class StudyIdentifiersController < ApplicationController
    skip_before_action :authenticate_user!

    def show
      headers["Access-Control-Allow-Origin"] = "*"
      token = TokenAuth::AuthenticationToken
              .find_by_client_uuid(params[:client_uuid])

      return render(json: {}) unless token

      participant = Participant.find_by_id(token.entity_id)

      return render(json: {}) unless participant

      study_identifier = participant.study_identifier

      render json: { study_identifier: study_identifier }
    end
  end
end
