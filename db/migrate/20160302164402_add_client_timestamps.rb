class AddClientTimestamps < ActiveRecord::Migration
  def change
    add_column :content_access_events, :client_created_at, :datetime
    add_column :content_access_events, :client_updated_at, :datetime
    add_column :devices, :client_created_at, :datetime
    add_column :devices, :client_updated_at, :datetime
    add_column :help_messages, :client_created_at, :datetime
    add_column :help_messages, :client_updated_at, :datetime
    add_column :logins, :client_created_at, :datetime
    add_column :logins, :client_updated_at, :datetime
    add_column :participant_start_dates, :client_created_at, :datetime
    add_column :participant_start_dates, :client_updated_at, :datetime
    add_column :planned_activities, :client_created_at, :datetime
    add_column :planned_activities, :client_updated_at, :datetime
    add_column :session_events, :client_created_at, :datetime
    add_column :session_events, :client_updated_at, :datetime
  end
end
