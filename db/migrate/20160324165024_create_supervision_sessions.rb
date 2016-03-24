class CreateSupervisionSessions < ActiveRecord::Migration
  def change
    create_table :supervision_sessions do |t|
      t.datetime :session_at, null: false
      t.integer :session_length, null: false
      t.string :meeting_kind, null: false
      t.string :contact_kind, null: false
      t.references :nurse, index: true, null: false
      t.text :topics

      t.timestamps null: false
    end
  end
end
