class RemoveFinalAppointemntAtAndFinalAppointmentLocationFromSecondContacts < ActiveRecord::Migration
  def change
    remove_column :second_contacts, :final_appointment_at
    remove_column :second_contacts, :final_appointment_location
  end
end
