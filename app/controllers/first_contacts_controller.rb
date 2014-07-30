# Handles First Contact info creation for active participant
class FirstContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @first_contact = participant.build_first_contact
  end

  def create
    @first_contact = participant.build_first_contact(first_contact_params)
    if @first_contact.save
      @first_contact.schedule_message(participant,
                                      "appointment")
      redirect_to active_participants_path,
                  notice: "Successfully created first contact"
    else
      flash[:alert] = @first_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @first_contact = participant.first_contact
  end

  def missed_appointment
    @first_contact = participant.first_contact
    @patient_contact = @first_contact.patient_contacts.build
  end

  def update
    @first_contact = participant.first_contact
    if @first_contact.update(first_contact_params)
      @first_contact.schedule_message(participant, "appointment")
      redirect_to active_participants_path,
                  notice: "Successfully updated first_contact"
    else
      flash[:alert] = @first_contact.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def first_contact_params
    params.require(:first_contact).permit(
        :participant_id, :contact_at, :first_appointment_at,
        :first_appointment_location, :alternative_contact_name,
        :alternative_contact_phone, patient_contacts_attributes: [
        :first_contact_id, :contact_reason, :participant_id,
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
