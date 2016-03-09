class AddActivityPlanningContentFieldsToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :pre_planning_content, :string
    add_column :lessons, :post_planning_content, :string
    add_column :lessons, :non_planning_content, :string
    add_column :lessons, :feedback_after_days, :integer
    add_column :lessons, :planning_response_yes_content, :string
    add_column :lessons, :planning_response_no_content, :string
    add_column :lessons, :non_planning_response_content, :string
  end
end
