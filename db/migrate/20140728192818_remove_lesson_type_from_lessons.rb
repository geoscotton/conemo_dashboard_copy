class RemoveLessonTypeFromLessons < ActiveRecord::Migration
  def change
    remove_column :lessons, :lesson_type
  end
end
