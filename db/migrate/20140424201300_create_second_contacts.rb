class CreateSecondContacts < ActiveRecord::Migration
  def change
    create_table :second_contacts do |t|
      t.references :participant, index: true, null: false
      t.date :contact_at, null: false
      t.boolean :video_access, default: true
      t.integer :session_length, null: false
      t.text :notes

      t.timestamps
    end
  end
end
