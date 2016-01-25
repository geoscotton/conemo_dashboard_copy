class AddUuidToContentAccessEvents < ActiveRecord::Migration
  def change
    add_column :content_access_events, :uuid, :string
    ContentAccessEvent.reset_column_information
    ContentAccessEvent.all.each { |h| h.update(uuid: SecureRandom.uuid) }
    change_column_null :content_access_events, :uuid, false
  end
end
