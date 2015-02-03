class RemoveNameFromResponsesAndChangeAnswerToText < ActiveRecord::Migration
  def up
    remove_column :responses, :name
    change_column :responses, :answer, :text
  end

  def down
    add_column :responses, :name, :string
    change_column :responses, :answer, :string
  end
end
