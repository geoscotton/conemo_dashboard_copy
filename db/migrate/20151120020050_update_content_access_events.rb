class UpdateContentAccessEvents < ActiveRecord::Migration
  def change
    remove_column :content_access_events, :dialogue_id, :integer
    change_column_null :content_access_events, :lesson_id, false
    change_column_null :content_access_events, :participant_id, false
    change_column_null :content_access_events, :day_in_treatment_accessed, false
    change_column_null :content_access_events, :accessed_at, false
    add_foreign_key :content_access_events, :lessons
    add_foreign_key :content_access_events, :participants
  end
end
