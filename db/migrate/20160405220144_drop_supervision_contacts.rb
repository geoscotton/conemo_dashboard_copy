class DropSupervisionContacts < ActiveRecord::Migration
  def change
    drop_table :supervision_contacts
  end
end
