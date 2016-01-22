class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :uuid, null: false
      t.string :device_uuid, null: false
      t.string :manufacturer, null: false
      t.string :model, null: false
      t.string :platform, null: false
      t.string :device_version, null: false
      t.datetime :inserted_at, null: false
      t.integer :participant_id

      t.timestamps null: false
    end

    add_index :devices, :uuid, unique: true
    add_index :devices, :device_uuid, unique: true
  end
end
