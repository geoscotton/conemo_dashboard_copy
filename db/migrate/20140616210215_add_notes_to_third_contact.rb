class AddNotesToThirdContact < ActiveRecord::Migration
  def change
    add_column :third_contacts, :notes, :text
  end
end
