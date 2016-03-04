class ModifyFirstAppointmentColumns < ActiveRecord::Migration
  def change
    remove_column :first_appointments, :smartphone_comfort, :string
    remove_column :first_appointments, :smart_phone_comfort_note, :text
    remove_column :first_appointments, :participant_session_engagement, :string
    remove_column :first_appointments, :app_usage_prediction, :string
  end
end
