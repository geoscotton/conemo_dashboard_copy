# Handles First Appointment info creation for active participant
class FirstAppointmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @first_appointment = participant.build_first_appointment
  end

  def create
    @first_appointment = participant
    .build_first_appointment(first_appointment_params)
    if @first_appointment.save
      @first_appointment.schedule_message(
          participant,
          "appointment"
      )
      redirect_to new_participant_smartphone_path,
                  notice: "Successfully created first appointment"
    else
      flash[:alert] = @first_appointment.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @first_appointment = participant.first_appointment
  end

  def missed_second_contact
    @first_appointment = participant.first_appointment
    @patient_contact = @first_appointment.patient_contacts.build
  end

  def update
    @first_appointment = participant.first_appointment
    if @first_appointment.update(first_appointment_params)
      @first_appointment.schedule_message(participant,
                                          "contact")
      redirect_to active_participants_path,
                  notice: "Successfully updated first_appointment"
    else
      flash[:alert] = @first_appointment.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def first_appointment_params
    params.require(:first_appointment).permit(
        :participant_id, :appointment_at, :appointment_location,
        :next_contact, :session_length, :notes,
        :smartphone_comfort, :participant_session_engagement,
        :app_usage_prediction,
        patient_contacts_attributes: [
            :first_appointment_id, :contact_reason, :participant_id,
            :note, :contact_at
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
