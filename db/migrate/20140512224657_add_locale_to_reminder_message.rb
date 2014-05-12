class AddLocaleToReminderMessage < ActiveRecord::Migration
  def change
    add_column :reminder_messages, :locale, :string
  end
end
