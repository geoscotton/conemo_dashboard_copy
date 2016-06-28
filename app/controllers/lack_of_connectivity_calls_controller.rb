# frozen_string_literal: true
# Manage Lack of Connectivity Calls.
class LackOfConnectivityCallsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @lack_of_connectivity_call = LackOfConnectivityCall.new(participant: find_participant)
    authorize! :create, @lack_of_connectivity_call
  end

  def create
    @lack_of_connectivity_call = LackOfConnectivityCall.new(lack_of_connectivity_call_params)
    authorize! :create, @lack_of_connectivity_call

    if @lack_of_connectivity_call.save
      redirect_to participant_tasks_url(@participant),
                  notice: [LackOfConnectivityCall.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @lack_of_connectivity_call.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def find_participant
    @participant ||= current_user.active_participants
                                 .find(params[:participant_id])
  end

  def lack_of_connectivity_call_params
    params
      .require(:lack_of_connectivity_call)
      .permit(:contact_at, :explanation)
      .merge(participant: find_participant)
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
