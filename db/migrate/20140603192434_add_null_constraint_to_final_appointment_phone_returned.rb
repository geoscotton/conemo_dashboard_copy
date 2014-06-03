class AddNullConstraintToFinalAppointmentPhoneReturned < ActiveRecord::Migration
  def change
    change_column :final_appointments, :phone_returned, :boolean, null: false
  end
end
