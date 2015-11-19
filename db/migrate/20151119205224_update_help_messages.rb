class UpdateHelpMessages < ActiveRecord::Migration
  def change
    add_foreign_key :help_messages, :participants
    change_column_null :help_messages, :message, false
    change_column_null :help_messages, :sent_at, false
    change_column_null :help_messages, :participant_id, false
    change_column_default :help_messages, :read, false
    change_column_null :help_messages, :read, false
  end
end
