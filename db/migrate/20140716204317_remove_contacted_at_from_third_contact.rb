class RemoveContactedAtFromThirdContact < ActiveRecord::Migration
  def change
    remove_column :third_contacts, :contacted_at
  end
end
