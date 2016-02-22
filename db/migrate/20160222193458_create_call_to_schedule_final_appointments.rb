class CreateCallToScheduleFinalAppointments < ActiveRecord::Migration
  def change
    create_table :call_to_schedule_final_appointments do |t|
      t.references :participant, foreign_key: true, null: false
      t.datetime :contact_at, null: false
      t.datetime :final_appointment_at, null: false
      t.string :final_appointment_location, null: false

      t.timestamps null: false
    end

    add_index :call_to_schedule_final_appointments, :participant_id, unique: true
  end
end
