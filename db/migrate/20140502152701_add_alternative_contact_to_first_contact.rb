class AddAlternativeContactToFirstContact < ActiveRecord::Migration
  def change
    add_column :first_contacts, :alternative_contact_name, :string
    add_column :first_contacts, :alternative_contact_phone, :string
  end
end
