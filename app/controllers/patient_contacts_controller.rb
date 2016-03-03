# frozen_string_literal: true
# Handles Patient Contact info creation for active participant
class PatientContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @patient_contact = find_participant.patient_contacts.build
  end

  def create
    @patient_contact = find_participant.patient_contacts.build(
      patient_contact_params
    )

    if @patient_contact.save
      redirect_to active_report_path(find_participant),
                  notice: "Successfully created patient contact"
    else
      flash[:alert] = @patient_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def destroy
    @patient_contact = PatientContact.find(params[:id])

    if @patient_contact.destroy
      redirect_to active_report_path(find_participant),
                  notice: "Successfully destroyed patient contact"
    else
      redirect_to participant_tasks_url(find_participant),
                  alert: "There were errors."
    end
  end

  private

  def patient_contact_params
    params.require(:patient_contact).permit(
      :participant_id, :contact_at, :contact_reason,
      :note
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
