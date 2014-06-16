class CreateThirdContacts < ActiveRecord::Migration
  def change
    create_table :third_contacts do |t|
      t.datetime :final_appointment_at
      t.string :final_appointment_location
      t.datetime :contacted_at
      t.integer :session_length
      t.references :participant, index: true

      t.timestamps
    end
  end
end
