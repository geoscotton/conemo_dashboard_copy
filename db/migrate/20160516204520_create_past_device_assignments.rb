class CreatePastDeviceAssignments < ActiveRecord::Migration
  def change
    create_table :past_device_assignments do |t|
      t.string :uuid
      t.string :device_uuid
      t.string :manufacturer
      t.string :model
      t.string :platform
      t.string :device_version
      t.datetime :inserted_at
      t.integer :participant_id
      t.datetime :last_seen_at
      t.datetime :client_created_at
      t.datetime :client_updated_at

      t.timestamps null: false
    end
  end
end
