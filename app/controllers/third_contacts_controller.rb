# Handles Third Contact info creation for active participant
class ThirdContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @third_contact = participant.build_third_contact
    @nurse_participant_evaluation = @third_contact
    .build_nurse_participant_evaluation
  end

  def create
    @third_contact = participant.build_third_contact(third_contact_params)
    if @third_contact.save
      @third_contact.schedule_message(participant, "final")
      redirect_to active_participants_path
    else
      flash[:alert] = @third_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @third_contact = participant.third_contact
    @nurse_participant_evaluation = @third_contact.nurse_participant_evaluation
  end

  def update
    @third_contact = participant.third_contact
    if @third_contact.update(third_contact_params)
      third_contact.schedule_message(participant, "final")
      redirect_to active_participants_path
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
    params.require(:third_contact).permit(
        :participant_id, :contacted_at,
        :notes, :session_length,
        :final_appointment_at,
        :final_appointment_location,
        patient_contacts_attributes: [
            :third_contact_id, :contact_reason, :participant_id,
            :note, :contact_at
        ],
        nurse_participant_evaluation_attributes: [
            :third_contact_id,
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