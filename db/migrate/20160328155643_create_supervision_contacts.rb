class CreateSupervisionContacts < ActiveRecord::Migration
  def change
    create_table :supervision_contacts do |t|
      t.datetime :contact_at, null: false
      t.string :contact_kind, null: false
      t.references :nurse, index: true, null: false
      t.text :notes

      t.timestamps null: false
    end
  end
end
