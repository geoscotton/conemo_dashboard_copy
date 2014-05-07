# Handles Patient Contact info creation for active participant
class PatientContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @patient_contact = PatientContact.new
  end

  def create
    @patient_contact = PatientContact.new(patient_contact_params)
    if @patient_contact.save
      redirect_to active_report_path(participant),
                  notice: "Successfully created patient contact"
    else
      flash[:alert] = @patient_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def destroy
    @patient_contact = PatientContact.where(id: params[:id]).first
    if @patient_contact.destroy
      flash[:success] = "Note deleted."
    else
      flash[:error] = "There were errors."
    end
    redirect_to active_report_path(participant)
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