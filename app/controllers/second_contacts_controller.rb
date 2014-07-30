# Handles Second Contact info creation for active participant
class SecondContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @second_contact = participant.build_second_contact
    @nurse_participant_evaluation = @second_contact
    .build_nurse_participant_evaluation
  end

  def create
    @second_contact = participant.build_second_contact(second_contact_params)
    if @second_contact.save
      @second_contact.schedule_message(participant, "third_contact")
      redirect_to active_participants_path
    else
      flash[:alert] = @second_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @second_contact = participant.second_contact
    @nurse_participant_evaluation = NurseParticipantEvaluation.find_or_initialize_by(second_contact: @second_contact)
  end

  def update
    @second_contact = participant.second_contact
    if @second_contact.update(second_contact_params)
      @second_contact.schedule_message(participant, "third_contact")
      redirect_to active_participants_path
    else
      flash[:alert] = @second_contact.errors.full_messages.join(", ")
      render :edit
    end
  end

  def missed_third_contact
    @second_contact = participant.second_contact
    @patient_contact = @second_contact.patient_contacts.build
  end

  private

  def second_contact_params
    params.require(:second_contact).permit(
        :participant_id, :contact_at, :video_access,
        :notes, :session_length, :next_contact,
        :q1, :q2, :q2_notes, :q3, :q3_notes, :q4, :q4_notes, 
        :q5, :q5_notes, :q6, :q6_notes, :q7, :q7_notes,
        patient_contacts_attributes: [
            :second_contact_id, :contact_reason, :participant_id,
            :note, :contact_at
        ],
        nurse_participant_evaluation_attributes: [
            :second_contact_id,
            :q1,
            :q2,
            :q3
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