class RemoveMessageFromReminderMessage < ActiveRecord::Migration
  def change
    remove_column :reminder_messages, :message
  end
end
