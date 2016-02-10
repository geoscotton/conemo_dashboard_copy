class AddNurseSupervisorIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nurse_supervisor_id, :integer
  end
end
