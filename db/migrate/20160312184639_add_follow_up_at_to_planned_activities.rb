class AddFollowUpAtToPlannedActivities < ActiveRecord::Migration
  def change
    add_column :planned_activities, :follow_up_at, :datetime
  end
end
