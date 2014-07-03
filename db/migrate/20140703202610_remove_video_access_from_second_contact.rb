class RemoveVideoAccessFromSecondContact < ActiveRecord::Migration
  def change
    remove_column :second_contacts, :video_access
  end
end
