# frozen_string_literal: true
# Manage Supervision Sessions.
class SupervisionSessionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    return redirect_to(root_url) unless current_user.respond_to?(:nurses)

    find_nurse
    authorize! :read, @nurse.supervision_sessions
  end

  def new
    return redirect_to(root_url) unless current_user.respond_to?(:nurses)

    @supervision_session = SupervisionSession.new(nurse: find_nurse)
    authorize! :create, @supervision_session
  end

  def create
    return redirect_to(root_url) unless current_user.respond_to?(:nurses)

    @supervision_session = SupervisionSession.new(supervision_session_params)
    authorize! :create, @supervision_session

    if @supervision_session.save
      redirect_to nurse_supervision_sessions_url(@nurse),
                  notice: [SupervisionSession.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @supervision_session.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def find_nurse
    @nurse ||= current_user.nurses.find(params[:nurse_id])
  end

  def supervision_session_params
    params
      .require(:supervision_session)
      .permit(:session_at, :session_length, :meeting_kind, :contact_kind,
              topics: [])
      .merge(nurse: find_nurse)
  end

  def record_not_found
    redirect_to nurse_supervisor_dashboard_url,
                alert: Nurse.model_name.human + " " + t(".not_found")
  end
end
