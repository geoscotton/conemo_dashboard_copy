class AddLastSeenAtToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_seen_at, :datetime
    Device.reset_column_information
    Device.all.each { |d| d.update last_seen_at: d.updated_at }
    change_column_null :devices, :last_seen_at, false
  end
end
