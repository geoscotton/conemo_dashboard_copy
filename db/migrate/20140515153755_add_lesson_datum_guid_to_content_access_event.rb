class AddLessonDatumGuidToContentAccessEvent < ActiveRecord::Migration
  def change
    add_column :content_access_events, :lesson_datum_guid, :string
  end
end
