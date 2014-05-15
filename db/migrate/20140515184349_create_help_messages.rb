class CreateHelpMessages < ActiveRecord::Migration
  def change
    create_table :help_messages do |t|
      t.references :participant, index: true
      t.text :message
      t.boolean :read
      t.string :staff_message_guid
      
      t.timestamps
    end
  end
end
