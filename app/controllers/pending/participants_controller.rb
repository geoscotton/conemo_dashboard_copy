# frozen_string_literal: true
module Pending
  # Managing pending participants.
  class ParticipantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      @unassigned_participants = Participant.unassigned.where(locale: params[:locale])
      authorize! :read, @unassigned_participants
    end

    def enroll
      @participant = Participant.find(params[:id])
      authorize! :update, @participant

      if @participant.update(status: Participant::PENDING)
        redirect_to pending_participants_path,
                    notice: "Successfully activated participant"
      else
        redirect_to pending_participants_path,
                    alert: @participant.errors.full_messages.join(", ")
      end
    end

    def activate
      @participant = Participant.find(params[:id])
      authorize! :read, @participant
      @nurses = User.where(role: "nurse", locale: params[:locale])
    end

    private

    def record_not_found
      redirect_to pending_participants_url, alert: "Participant not found"
    end
  end
end
