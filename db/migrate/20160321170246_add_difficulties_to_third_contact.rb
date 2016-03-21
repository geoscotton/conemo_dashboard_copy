class AddDifficultiesToThirdContact < ActiveRecord::Migration
  def change
    add_column :third_contacts, :difficulties, :string
  end
end
