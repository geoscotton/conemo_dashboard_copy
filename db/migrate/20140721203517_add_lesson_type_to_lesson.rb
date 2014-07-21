class AddLessonTypeToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :lesson_type, :string, default: "default"
  end
end
