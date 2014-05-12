class AddTypeToReminderMessage < ActiveRecord::Migration
  def change
    add_column :reminder_messages, :type, :string
  end
end
