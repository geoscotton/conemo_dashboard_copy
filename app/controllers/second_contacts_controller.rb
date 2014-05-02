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
      redirect_to active_participants_path,
                  notice: "Successfully created second contact"
    else
      flash[:alert] = @second_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @second_contact = participant.second_contact
  end

  def update
    @second_contact = participant.second_contact
    if @second_contact.update(second_contact_params)
      redirect_to active_participant_path(participant),
                  notice: "Successfully updated second_contact"
    else
      flash[:alert] = @second_contact.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def second_contact_params
    params.require(:second_contact).permit(
      :participant_id, :contact_at, :video_access,
      :notes, :session_length,
      nurse_participant_evaluation_attributes: [
        :first_appointment_id,
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