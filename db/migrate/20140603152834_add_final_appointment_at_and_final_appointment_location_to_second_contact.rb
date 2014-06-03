class AddFinalAppointmentAtAndFinalAppointmentLocationToSecondContact < ActiveRecord::Migration
  def change
    add_column :second_contacts, :final_appointment_at, :datetime
    add_column :second_contacts, :final_appointment_location, :string
  end
end
