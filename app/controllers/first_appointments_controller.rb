# Handles First Appointment info creation for active participant
class FirstAppointmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @first_appointment = participant.build_first_appointment
    @nurse_participant_evaluation = @first_appointment
                                      .build_nurse_participant_evaluation
  end

  def create
    @first_appointment = participant
                          .build_first_appointment(first_appointment_params)
    if @first_appointment.save
      redirect_to new_participant_smartphone_path,
                  notice: "Successfully created first appointment"
    else
      flash[:alert] = @first_appointment.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def first_appointment_params
    params.require(:first_appointment).permit(
      :participant_id, :appointment_at, :appointment_location,
      :next_contact, :session_length, :notes,
      nurse_participant_evaluation_attributes: [
        :first_appointment_id,
        :smartphone_comfort,
        :participant_session_engagement,
        :app_usage_prediction
      ]
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