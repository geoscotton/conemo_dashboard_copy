class RemoveUserIdFromNurseTasks < ActiveRecord::Migration
  def change
    remove_column :nurse_tasks, :user_id, :integer
  end
end
