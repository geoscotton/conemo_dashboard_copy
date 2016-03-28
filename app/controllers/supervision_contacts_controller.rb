# frozen_string_literal: true
# Manage Supervision Contacts.
class SupervisionContactsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @supervision_contact = SupervisionContact.new(nurse: find_nurse)
    authorize! :create, @supervision_contact
  end

  def create
    @supervision_contact = SupervisionContact.new(supervision_contact_params)
    authorize! :create, @supervision_contact

    if @supervision_contact.save
      redirect_to nurse_supervisor_dashboard_url,
                  notice: @supervision_contact.model_name.human + " " +
                          t(".success")
    else
      flash[:alert] = @supervision_contact.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def find_nurse
    @nurse ||= current_user.nurses.find(params[:nurse_id])
  end

  def supervision_contact_params
    params
      .require(:supervision_contact)
      .permit(:contact_at, :contact_kind, :notes)
      .merge(nurse: find_nurse)
  end

  def record_not_found
    redirect_to nurse_supervisor_dashboard_url,
                alert: Nurse.model_name.human + " " + t(".not_found")
  end
end
