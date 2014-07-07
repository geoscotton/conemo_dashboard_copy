class AddNurseEvaluationFieldsToFirstAppointment < ActiveRecord::Migration
  def change
    add_column :first_appointments, :smartphone_comfort, :string
    add_column :first_appointments, :participant_session_engagement, :string
    add_column :first_appointments, :app_usage_prediction, :string
  end
end
