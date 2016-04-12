# frozen_string_literal: true
# Handles smartphone info creation for active participant
class SmartphonesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @smartphone = find_participant.build_smartphone
  end

  def create
    @smartphone = find_participant.build_smartphone(smartphone_params)

    if @smartphone.save
      successfully_saved
    else
      flash[:alert] = @smartphone.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @smartphone = find_participant.smartphone
  end

  def update
    @smartphone = find_participant.smartphone

    if @smartphone.update(smartphone_params)
      successfully_saved
    else
      flash[:alert] = @smartphone.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def smartphone_params
    params.require(:smartphone).permit(:number, :phone_identifier)
  end

  def find_participant
    @participant ||= Participant.find(params[:participant_id])
  end

  def record_not_found
    redirect_to nurse_dashboard_url(current_user),
                alert: "Participant not found"
  end

  def successfully_saved
    redirect_to participant_tasks_url(find_participant),
                notice: [Smartphone.model_name.human,
                         t("actioncontroller.saved_m"),
                         t("actioncontroller.successfully")].join(" ")
  end
end
