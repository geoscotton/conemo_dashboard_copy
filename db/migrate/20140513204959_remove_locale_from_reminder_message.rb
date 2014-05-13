class RemoveLocaleFromReminderMessage < ActiveRecord::Migration
  def change
    remove_column :reminder_messages, :locale
  end
end
