class AddStatusToReminderMessage < ActiveRecord::Migration
  def change
    add_column :reminder_messages, :status, :string, default: "pending"
  end
end
