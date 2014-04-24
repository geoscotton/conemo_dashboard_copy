class CreateFirstAppointments < ActiveRecord::Migration
  def change
    create_table :first_appointments do |t|
      t.references :participant, index: true, null: false
      t.datetime :appointment_at, null: false
      t.string :appointment_location, null: false
      t.integer :session_length, null: false
      t.datetime :next_contact, null: false
      t.text :notes

      t.timestamps
    end
  end
end
