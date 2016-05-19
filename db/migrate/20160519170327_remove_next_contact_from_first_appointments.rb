class RemoveNextContactFromFirstAppointments < ActiveRecord::Migration
  def change
    remove_column :first_appointments, :next_contact, :datetime
  end
end
