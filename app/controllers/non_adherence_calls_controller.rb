# frozen_string_literal: true
# Manage Non Adherence Calls.
class NonAdherenceCallsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @non_adherence_call = NonAdherenceCall.new(participant: find_participant)
    authorize! :create, @non_adherence_call
  end

  def create
    @non_adherence_call = NonAdherenceCall.new(non_adherence_call_params)
    authorize! :create, @non_adherence_call

    if @non_adherence_call.save
      redirect_to participant_tasks_url(@participant),
                  notice: [NonAdherenceCall.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @non_adherence_call.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def find_participant
    @participant ||= current_user.active_participants
                                 .find(params[:participant_id])
  end

  def non_adherence_call_params
    params
      .require(:non_adherence_call)
      .permit(:contact_at, :explanation)
      .merge(participant: find_participant)
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
