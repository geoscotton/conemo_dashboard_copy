# Handles First Appointment info creation for active participant
class FinalAppointmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @final_appointment = participant.build_final_appointment
  end

  def create
    @final_appointment = participant
    .build_final_appointment(final_appointment_params)
    if @final_appointment.save
      redirect_to active_participants_path,
                  notice: "Successfully created first appointment"
    else
      flash[:alert] = @final_appointment.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @final_appointment = participant.final_appointment
  end

  def update
    @final_appointment = participant.final_appointment
    if @final_appointment.update(final_appointment_params)
      redirect_to active_participants_path,
                  notice: "Successfully updated final_appointment"
    else
      flash[:alert] = @final_appointment.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def final_appointment_params
    params.require(:final_appointment).permit(
        :participant_id, :appointment_at,
        :appointment_location, :phone_returned, :notes
    )
  end

  def participant
    Participant.find(params[:participant_id])
  end

  helper_method :participant

  def record_not_found
    redirect_to active_participants_url, alert: "Participant not found"
  end
end