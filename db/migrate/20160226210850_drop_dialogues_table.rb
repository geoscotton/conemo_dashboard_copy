class DropDialoguesTable < ActiveRecord::Migration
  def change
    drop_table :dialogues
  end
end
