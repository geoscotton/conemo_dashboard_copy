class AddFinalCallToThirdContact < ActiveRecord::Migration
  def change
    rename_column :third_contacts, :final_appointment_at, :call_to_schedule_final_appointment_at
    remove_column :third_contacts, :final_appointment_location, :string
  end
end
