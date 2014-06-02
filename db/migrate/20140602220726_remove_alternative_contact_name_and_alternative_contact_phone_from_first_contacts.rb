class RemoveAlternativeContactNameAndAlternativeContactPhoneFromFirstContacts < ActiveRecord::Migration
  def change
    remove_column :first_contacts, :alternative_contact_name
    remove_column :first_contacts, :alternative_contact_phone
  end
end
