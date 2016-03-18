class RemoveNurseIdFromAdditionalContact < ActiveRecord::Migration
  def change
    remove_column :additional_contacts, :nurse_id, :integer
  end
end
