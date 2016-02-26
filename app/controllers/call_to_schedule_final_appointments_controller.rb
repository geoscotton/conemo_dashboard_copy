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
      redirect_to active_participants_path,
                  notice: "Successfully created call"
    else
      flash[:alert] =
        @call_to_schedule_final_appointment.errors.full_messages.join(", ")
      render :new
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
    redirect_to active_participants_url, alert: "Participant not found"
  end
end
