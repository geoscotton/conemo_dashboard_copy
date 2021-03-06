# frozen_string_literal: true
# Handles First Appointment info creation for active participant
class FirstAppointmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def self.filter_params(params)
    params.require(:first_appointment).permit(
      :appointment_at, :appointment_location, :next_contact, :session_length,
      :notes, :smartphone_comfort, :smart_phone_comfort_note,
      :participant_session_engagement, :app_usage_prediction,
      patient_contacts_attributes: [:contact_reason, :note]
    )
  end

  def new
    @first_appointment = find_participant.first_appointment ||
                         find_participant.build_first_appointment
  end

  def create
    @first_appointment =
      find_participant.build_first_appointment(self.class.filter_params(params))

    if @first_appointment.save
      redirect_to new_participant_smartphone_path,
                  notice: [FirstAppointment.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @first_appointment.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @first_appointment = find_participant.first_appointment
  end

  def update
    @first_appointment = find_participant.first_appointment

    if @first_appointment.update(self.class.filter_params(params))
      redirect_to active_participant_url(find_participant),
                  notice: [FirstAppointment.model_name.human,
                           t("actioncontroller.saved"),
                           t("actioncontroller.successfully")].join(" ")
    else
      flash[:alert] = @first_appointment.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def find_participant
    @participant ||= Participant.find(params[:participant_id])
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end
end
