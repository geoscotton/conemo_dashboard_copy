class AddNextContactToSecondContacts < ActiveRecord::Migration
  def change
    add_column :second_contacts, :next_contact, :datetime
  end
end
