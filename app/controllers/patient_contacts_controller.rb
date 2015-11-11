# Handles Patient Contact info creation for active participant
class PatientContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @patient_contact = participant.patient_contacts.build
  end

  def create
    @patient_contact = participant.patient_contacts.build(
      patient_contact_params
    )

    if @patient_contact.save
      if @patient_contact.participant.start_date
        redirect_to active_report_path(participant),
                    notice: "Successfully created patient contact"
      else
        redirect_to active_participants_path
      end
    else
      flash[:alert] = @patient_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def destroy
    @patient_contact = PatientContact.find(params[:id])
    
    if @patient_contact.destroy
      if @patient_contact.participant.start_date
        redirect_to active_report_path(participant)
      else
        redirect_to active_participants_path
      end
    else
      redirect_to active_participants_path, alert: "There were errors."
    end
  end

  private

  def patient_contact_params
    params.require(:patient_contact).permit(
        :participant_id, :contact_at, :contact_reason,
        :note
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
