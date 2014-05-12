class AddNotifyAtToReminderMessage < ActiveRecord::Migration
  def change
    add_column :reminder_messages, :notify_at, :datetime
  end
end
