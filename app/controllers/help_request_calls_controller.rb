# frozen_string_literal: true
# Manage Help Request Calls.
class HelpRequestCallsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @help_request_call = HelpRequestCall.new(participant: find_participant)
    authorize! :create, @help_request_call
  end

  def create
    @help_request_call = HelpRequestCall.new(help_request_call_params)
    authorize! :create, @help_request_call

    if @help_request_call.save
      redirect_to participant_tasks_url(@participant),
                  notice: [HelpRequestCall.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @help_request_call.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def find_participant
    @participant ||= current_user.active_participants
                                 .find(params[:participant_id])
  end

  def help_request_call_params
    params
      .require(:help_request_call)
      .permit(:contact_at, :explanation)
      .merge(participant: find_participant)
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
