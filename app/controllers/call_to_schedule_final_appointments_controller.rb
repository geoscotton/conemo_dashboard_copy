# frozen_string_literal: true
# Handles CallToScheduleFinalAppointment management.
class CallToScheduleFinalAppointmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @call_to_schedule_final_appointment =
      CallToScheduleFinalAppointment.build_for_participant(find_participant)
    authorize! :create, @call_to_schedule_final_appointment
  end

  def create
    @call_to_schedule_final_appointment =
      CallToScheduleFinalAppointment.build_for_participant(find_participant,
                                                           call_params)
    authorize! :create, @call_to_schedule_final_appointment

    if @call_to_schedule_final_appointment.save
      redirect_to participant_tasks_url(find_participant),
                  notice: [CallToScheduleFinalAppointment.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] =
        @call_to_schedule_final_appointment.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @call_to_schedule_final_appointment =
      find_participant.call_to_schedule_final_appointment
    authorize! :update, @call_to_schedule_final_appointment
  end

  def update
    @call_to_schedule_final_appointment =
      find_participant.call_to_schedule_final_appointment
    authorize! :update, @call_to_schedule_final_appointment

    if @call_to_schedule_final_appointment.update(call_params)
      redirect_to active_participant_url(find_participant),
                  notice: [CallToScheduleFinalAppointment.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @call_to_schedule_final_appointment
                      .errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def find_participant
    @participant ||= Participant.active.find(params[:participant_id])
  end

  def call_params
    params.require(:call_to_schedule_final_appointment)
          .permit(:contact_at, :final_appointment_at,
                  :final_appointment_location)
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
