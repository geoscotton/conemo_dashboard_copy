class AddActivityChoicesToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :activity_choices, :text
  end
end
