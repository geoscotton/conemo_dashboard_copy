class RemoveNurseSupervisorIdFromNotifications < ActiveRecord::Migration
  def change
    remove_column :supervisor_notifications, :nurse_supervisor_id
  end
end
