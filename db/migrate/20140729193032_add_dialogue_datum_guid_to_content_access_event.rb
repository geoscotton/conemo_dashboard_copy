class AddDialogueDatumGuidToContentAccessEvent < ActiveRecord::Migration
  def change
    add_column :content_access_events, :dialogue_datum_guid, :string
  end
end
