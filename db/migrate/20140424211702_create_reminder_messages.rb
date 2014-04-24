class CreateReminderMessages < ActiveRecord::Migration
  def change
    create_table :reminder_messages do |t|
      t.references :nurse, index: true, null: false
      t.references :participant, index: true, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
