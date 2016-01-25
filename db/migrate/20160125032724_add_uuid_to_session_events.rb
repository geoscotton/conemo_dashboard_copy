class AddUuidToSessionEvents < ActiveRecord::Migration
  def change
    add_column :session_events, :uuid, :string
    SessionEvent.reset_column_information
    SessionEvent.all.each { |h| h.update(uuid: SecureRandom.uuid) }
    change_column_null :session_events, :uuid, false
  end
end
