class RemoveReadFromHelpMessages < ActiveRecord::Migration
  def change
    remove_column :help_messages, :read, :boolean, default: false
  end
end
