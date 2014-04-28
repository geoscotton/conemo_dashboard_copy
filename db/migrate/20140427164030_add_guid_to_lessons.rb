class AddGuidToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :guid, :string, null: false
  end
end
