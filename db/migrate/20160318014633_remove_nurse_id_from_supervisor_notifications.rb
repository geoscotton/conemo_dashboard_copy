class RemoveNurseIdFromSupervisorNotifications < ActiveRecord::Migration
  def change
    remove_column :supervisor_notifications, :nurse_id, :integer
  end
end
