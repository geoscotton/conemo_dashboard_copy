# frozen_string_literal: true
# Handles First Contact info creation for active participant
class FirstContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @first_contact = find_participant.first_contact ||
                     find_participant.build_first_contact
  end

  def create
    @first_contact = find_participant.build_first_contact(first_contact_params)

    if @first_contact.save
      redirect_to participant_tasks_url(find_participant),
                  notice: [FirstContact.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @first_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @first_contact = find_participant.first_contact
  end

  def missed_appointment
    @first_contact = find_participant.first_contact
    @patient_contact = @first_contact.patient_contacts.build
  end

  def update
    @first_contact = find_participant.first_contact

    if @first_contact.update(first_contact_params)
      redirect_to active_participant_url(find_participant),
                  notice: [FirstContact.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @first_contact.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def first_contact_params
    params.require(:first_contact).permit(
      :contact_at, :first_appointment_at, :first_appointment_location,
      :alternative_contact_name, :alternative_contact_phone,
      patient_contacts_attributes: [
        :first_contact_id, :contact_reason, :note, :contact_at
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
