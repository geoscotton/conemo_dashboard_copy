class CreateFinalAppointments < ActiveRecord::Migration
  def change
    create_table :final_appointments do |t|
      t.datetime :appointment_at
      t.string :appointment_location
      t.boolean :phone_returned
      t.text :notes

      t.timestamps
    end
  end
end
