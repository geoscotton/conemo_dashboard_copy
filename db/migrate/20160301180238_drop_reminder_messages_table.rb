class DropReminderMessagesTable < ActiveRecord::Migration
  def change
    drop_table :reminder_messages
  end
end
