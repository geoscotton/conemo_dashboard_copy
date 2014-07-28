class AddDialogueIndexToContentAccessEvent < ActiveRecord::Migration
  def change
    add_reference :content_access_events, :dialogue, index: true
  end
end
