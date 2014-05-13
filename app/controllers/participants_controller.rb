# Creating, Editing, Updating, and Deleting all participants.
class ParticipantsController < ApplicationController
  def new
    @participant = Participant.new
  end

  def create
    @participant = Participant.new(participant_params)
    @participant.locale = params[:locale]
    if @participant.save
      redirect_to pending_participants_path,
                  notice: "Successfully created participant"
    else
      flash[:alert] = @participant.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @participant = Participant.where(id: params[:id]).first
  end

  def update
    @participant = Participant.where(id: params[:id]).first
    if @participant.update(participant_params)
      after_update_path(@participant)
    else
      flash[:alert] = @participant.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @participant = Participant.where(id: params[:id]).first
    if @participant.destroy
      flash[:success] = "Participant deleted."
    else
      flash[:error] = "There were errors."
    end
    redirect_to pending_participants_path
  end

  private

  def participant_params
    params.require(:participant).permit(
      :first_name, :last_name, :study_identifier,
      :email, :phone, :secondary_phone, :family_health_unit_name,
      :family_record_number, :date_of_birth, :address,
      :enrollment_date, :key_chronic_disorder, :gender, :status,
      :locale, :nurse_id
    )
  end

  def after_update_path(participant)
    if participant.status == "active"
      redirect_to active_participants_path,
                  notice: "Successfully updated participant"
    else
      redirect_to pending_participants_path,
                  notice: "Successfully updated participant"
    end
  end
end