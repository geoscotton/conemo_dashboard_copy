class ChangeTypeToMessageTypeForReminderMessage < ActiveRecord::Migration
  def change
    rename_column :reminder_messages, :type, :message_type
  end
end
