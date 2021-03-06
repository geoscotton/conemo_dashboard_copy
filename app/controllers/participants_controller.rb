# frozen_string_literal: true
# Creating, Editing, Updating, and Deleting all participants.
class ParticipantsController < ApplicationController
  TASKS_PAGE = "tasks"

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
                  notice: t("actioncontroller.participants.saved_participant") +
                          " " + t("actioncontroller.successfully")
    else
      flash[:alert] = @participant.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @participant = Participant.where(id: params[:id]).first
    authorize! :update, @participant
    referrer
  end

  def update
    @participant = Participant.where(id: params[:id]).first
    authorize! :update, @participant
    referrer

    if @participant.update(participant_params)
      after_update_path
    else
      flash[:alert] = @participant.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def referrer
    @referrer ||= params[:referrer]
  end

  def participant_params
    params.require(:participant).permit(
      :first_name, :last_name, :study_identifier,
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
    flash[:notice] = t("actioncontroller.participants.saved_participant") +
                     " " + t("actioncontroller.successfully")

    if current_user.nurse? || referrer == TASKS_PAGE
      redirect_to participant_tasks_url(@participant)
    else
      redirect_to root_url(locale: current_user.locale)
    end
  end
end
