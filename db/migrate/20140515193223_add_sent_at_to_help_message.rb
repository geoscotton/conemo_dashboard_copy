class AddSentAtToHelpMessage < ActiveRecord::Migration
  def change
    add_column :help_messages, :sent_at, :datetime
  end
end
