class RemoveUniqueConstraintFromDevices < ActiveRecord::Migration
  def change
    remove_index :devices, :device_uuid
    add_index :devices, [:device_uuid, :participant_id], unique: true
  end
end
