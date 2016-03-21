class AddDifficultiesToSecondContacts < ActiveRecord::Migration
  def change
    add_column :second_contacts, :difficulties, :string
  end
end
