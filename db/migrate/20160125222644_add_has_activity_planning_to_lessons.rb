class AddHasActivityPlanningToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :has_activity_planning, :boolean, default: false, null: false
  end
end
