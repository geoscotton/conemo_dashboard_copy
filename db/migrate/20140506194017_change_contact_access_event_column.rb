class ChangeContactAccessEventColumn < ActiveRecord::Migration
  def change
    remove_reference :content_access_events, :content_release
    add_reference :content_access_events, :lesson, index: true
  end
end
