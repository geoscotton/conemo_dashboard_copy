class AddSmartPhoneComfortNoteToFirstAppointment < ActiveRecord::Migration
  def change
    add_column :first_appointments, :smart_phone_comfort_note, :text
  end
end
