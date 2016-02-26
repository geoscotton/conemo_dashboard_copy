# frozen_string_literal: true
# Render release version data.
class VersionsController < ActionController::Base
  def show
    version = Rails.application.class.parent::VERSION

    respond_to do |format|
      format.text { render text: version }
      format.json { render json: { value: version } }
    end
  end
end
