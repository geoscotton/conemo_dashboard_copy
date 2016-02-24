class AddLastSeenAtToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_seen_at, :datetime
  end
end
