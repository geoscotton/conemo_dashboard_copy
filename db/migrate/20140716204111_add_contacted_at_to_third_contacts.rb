class AddContactedAtToThirdContacts < ActiveRecord::Migration
  def change
    add_column :third_contacts, :contact_at, :datetime
  end
end
