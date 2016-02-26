class CreateAdditionalContacts < ActiveRecord::Migration
  def change
    create_table :additional_contacts do |t|
      t.references :participant, index: true, foreign_key: true, null: false
      t.references :nurse, index: true, null: false
      t.datetime :scheduled_at, null: false
      t.string :kind, null: false

      t.timestamps null: false
    end

    add_foreign_key :additional_contacts, :users, column: :nurse_id
  end
end
