# frozen_string_literal: true
# Handles Third Contact info creation for active participant
class ThirdContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def self.filter_params(params)
    params.require(:third_contact).permit(
      :contact_at, :session_length,
      :notes,
      difficulties: [],
      patient_contacts_attributes: [:contact_reason, :note]
    )
  end

  def new
    @third_contact = find_participant.third_contact ||
                     find_participant.build_third_contact
  end

  def create
    @third_contact = find_participant.build_third_contact(third_contact_params)

    if @third_contact.save
      redirect_to participant_tasks_url(find_participant),
                  notice: [ThirdContact.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @third_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @third_contact = find_participant.third_contact
  end

  def update
    @third_contact = find_participant.third_contact

    if @third_contact.update(third_contact_params)
      redirect_to active_participant_url(find_participant),
                  notice: [ThirdContact.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @third_contact.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def third_contact_params
    self.class.filter_params params
  end

  def find_participant
    @participant ||= Participant.find(params[:participant_id])
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
