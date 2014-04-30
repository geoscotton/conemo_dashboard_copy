# Handles Second Contact info creation for active participant
class SecondContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @second_contact = participant.build_second_contact
  end

  def create
    @second_contact = participant.build_second_contact(second_contact_params)
    if @second_contact.save
      redirect_to active_participants_path,
                  notice: "Successfully created second contact"
    else
      flash[:alert] = @second_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def second_contact_params
    params.require(:second_contact).permit(
      :participant_id, :contact_at, :second_appointment_at,
      :second_appointment_location
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