class CreateFirstContacts < ActiveRecord::Migration
  def change
    create_table :first_contacts do |t|
      t.references :participant, index: true, null: false
      t.datetime :contact_at, null: false
      t.datetime :first_appointment_at, null: false
      t.string :first_appointment_location, null: false

      t.timestamps
    end
  end
end
