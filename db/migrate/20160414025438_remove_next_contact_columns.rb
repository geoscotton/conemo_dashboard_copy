class RemoveNextContactColumns < ActiveRecord::Migration
  def change
    remove_column :second_contacts, :next_contact, :datetime
    remove_column :third_contacts, :call_to_schedule_final_appointment_at, :datetime
  end
end
