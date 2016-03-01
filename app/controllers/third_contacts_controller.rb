# frozen_string_literal: true
# Handles Third Contact info creation for active participant
class ThirdContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def self.filter_params(params)
    params.require(:third_contact).permit(
      :contact_at, :session_length, :call_to_schedule_final_appointment_at,
      :q1, :q2, :q2_notes, :q3, :q3_notes, :q4,
      :q4_notes, :q5, :q5_notes, :notes,
      patient_contacts_attributes: [:contact_reason, :note],
      nurse_participant_evaluation_attributes: [:q1, :q2]
    )
  end

  def new
    @third_contact = participant.build_third_contact
    @nurse_participant_evaluation =
      @third_contact.build_nurse_participant_evaluation
  end

  def create
    @third_contact = participant.build_third_contact(third_contact_params)
    if @third_contact.save
      redirect_to participant_tasks_url(participant)
    else
      flash[:alert] = @third_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @third_contact = participant.third_contact
    @nurse_participant_evaluation = NurseParticipantEvaluation.where(
      third_contact_id: @third_contact.id
    ).first_or_initialize
  end

  def update
    @third_contact = participant.third_contact
    if @third_contact.update(third_contact_params)
      redirect_to participant_tasks_url(participant)
    else
      flash[:alert] = @third_contact.errors.full_messages.join(", ")
      render :edit
    end
  end

  def missed_final_appointment
    @third_contact = participant.third_contact
    @patient_contact = @third_contact.patient_contacts.build
  end

  private

  def third_contact_params
    self.class.filter_params params
  end

  def participant
    Participant.find(params[:participant_id])
  end

  helper_method :participant

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
