class AddAppointmentTypeToReminderMessage < ActiveRecord::Migration
  def change
    add_column :reminder_messages, :appointment_type, :string
  end
end