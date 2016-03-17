# frozen_string_literal: true
# Manage Additional Contacts.
class AdditionalContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @additional_contact = AdditionalContact.new(participant: find_participant)
    authorize! :create, @additional_contact
  end

  def create
    @additional_contact = AdditionalContact.new(additional_contact_params)
    authorize! :create, @additional_contact

    if @additional_contact.save
      redirect_to participant_tasks_url(@participant),
                  notice: "Additional contact saved successfully"
    else
      flash[:alert] = @additional_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def find_participant
    @participant ||= current_user.active_participants
                                 .find(params[:participant_id])
  end

  def additional_contact_params
    params
      .require(:additional_contact)
      .permit(:scheduled_at, :kind)
      .merge(participant: find_participant)
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
