# Handles smartphone info creation for active participant
class SmartphonesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @smartphone = participant.build_smartphone
  end

  def create
    @smartphone = participant.build_smartphone(smartphone_params)
    if @smartphone.save
      redirect_to active_participants_path,
                  notice: "Successfully created smartphone"
    else
      flash[:alert] = @smartphone.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @smartphone = participant.smartphone
  end

  def update
    @smartphone = participant.smartphone
    if @smartphone.update(smartphone_params)
      redirect_to active_participant_path(participant),
                  notice: "Successfully updated smartphone"
    else
      flash[:alert] = @smartphone.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def smartphone_params
    params.require(:smartphone).permit(
        :participant_id, :number, :is_app_compatible,
        :is_owned_by_participant, :is_smartphone_owner
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
