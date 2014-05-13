class ChangeNotifyAtFromDateTimeToString < ActiveRecord::Migration
  def change
    change_column :reminder_messages, :notify_at, :string
  end
end
