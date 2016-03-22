# frozen_string_literal: true
# Creating, Editing, Updating, and Deleting all participants.
class ParticipantsController < ApplicationController
  def new
    @participant = Participant.new(locale: current_user.locale)
    authorize! :create, @participant
  end

  def create
    @participant = Participant.new(
      participant_params.merge(locale: current_user.locale)
    )
    authorize! :create, @participant

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
    authorize! :update, @participant
  end

  def update
    @participant = Participant.where(id: params[:id]).first
    authorize! :update, @participant

    if @participant.update(participant_params)
      after_update_path
    else
      flash[:alert] = @participant.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @participant = Participant.where(id: params[:id]).first
    authorize! :destroy, @participant

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
      :first_name, :last_name, :study_identifier, :enrollment_date,
      :family_health_unit_name, :address, :phone, :cell_phone,
      :alternate_phone_1, :contact_person_1_name,
      :contact_person_1_relationship, :contact_person_1_other_relationship,
      :alternate_phone_2, :contact_person_2_name,
      :contact_person_2_relationship, :contact_person_2_other_relationship,
      :date_of_birth, :gender, :emergency_contact_name,
      :emergency_contact_relationship, :emergency_contact_other_relationship,
      :emergency_contact_address, :emergency_contact_phone,
      :emergency_contact_cell_phone, :status, :nurse_id
    )
  end

  def after_update_path
    if current_user.nurse?
      redirect_to active_participant_url(@participant),
                  notice: "Successfully updated participant"
    else
      redirect_to pending_participants_path,
                  notice: "Successfully updated participant"
    end
  end
end
