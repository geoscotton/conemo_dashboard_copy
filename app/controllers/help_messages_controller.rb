# frozen_string_literal: true
# Handles Help Message updates for active participant
class HelpMessagesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def update
    @help_message = HelpMessage.where(id: params[:id]).first
    if @help_message.update(help_message_params)
      redirect_to active_report_path(participant),
                  notice: "Successfully updated help message"
    else
      flash[:alert] = @help_message.errors.full_messages.join(", ")
      redirect_to active_report_path(participant)
    end
  end

  private

  def help_message_params
    params.require(:help_message).permit(
      :participant_id, :read
    )
  end

  def participant
    Participant.find(params[:participant_id])
  end

  helper_method :participant

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
