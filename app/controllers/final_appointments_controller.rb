# frozen_string_literal: true
# Handles First Appointment info creation for active participant
class FinalAppointmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @final_appointment = find_participant.build_final_appointment
  end

  def create
    @final_appointment = find_participant
                         .build_final_appointment(final_appointment_params)
    if @final_appointment.save
      redirect_to participant_tasks_url(find_participant),
                  notice: "Successfully created first appointment"
    else
      flash[:alert] = @final_appointment.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @final_appointment = find_participant.final_appointment
  end

  def update
    @final_appointment = find_participant.final_appointment
    if @final_appointment.update(final_appointment_params)
      redirect_to participant_tasks_url(find_participant),
                  notice: "Successfully updated final_appointment"
    else
      flash[:alert] = @final_appointment.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def final_appointment_params
    params.require(:final_appointment).permit(
      :appointment_at, :appointment_location, :phone_returned, :notes
    )
  end

  def find_participant
    @participant ||= Participant.find(params[:participant_id])
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
