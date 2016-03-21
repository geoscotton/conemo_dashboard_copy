# frozen_string_literal: true
# Handles Second Contact info creation for active participant
class SecondContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @second_contact = find_participant.build_second_contact
  end

  def create
    @second_contact = find_participant
                      .build_second_contact(second_contact_params)
    if @second_contact.save
      redirect_to participant_tasks_url(find_participant)
    else
      flash[:alert] = @second_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @second_contact = find_participant.second_contact
  end

  def update
    @second_contact = find_participant.second_contact
    if @second_contact.update(second_contact_params)
      redirect_to participant_tasks_url(find_participant)
    else
      flash[:alert] = @second_contact.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def second_contact_params
    params.require(:second_contact).permit(
      :contact_at, :notes, :session_length, :next_contact, :difficulties,
      patient_contacts_attributes: [
        :second_contact_id, :contact_reason, :note, :contact_at
      ]
    )
  end

  def find_participant
    @participant ||= Participant.find(params[:participant_id])
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
