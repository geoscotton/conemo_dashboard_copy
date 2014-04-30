# Handles First Contact info creation for active participant
class FirstContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @first_contact = participant.build_first_contact
  end

  def create
    @first_contact = participant.build_first_contact(first_contact_params)
    if @first_contact.save
      redirect_to active_participants_path,
                  notice: "Successfully created first contact"
    else
      flash[:alert] = @first_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def first_contact_params
    params.require(:first_contact).permit(
      :participant_id, :contact_at, :first_appointment_at,
      :first_appointment_location
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