class ChangeNullContstraintOnFirstAppointment < ActiveRecord::Migration
  def change
    change_column :first_appointments, :appointment_location, :string, null: true
    change_column :first_contacts, :first_appointment_location, :string, null: true
  end
end
