class ChangeContactAtToDateTimeOnSecondContacts < ActiveRecord::Migration
  def change
    change_column :second_contacts, :contact_at, :datetime, null: false
  end
end
