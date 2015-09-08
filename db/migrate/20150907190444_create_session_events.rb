class CreateSessionEvents < ActiveRecord::Migration
  def change
    create_table :session_events do |t|
      t.references :participant, index: true, null: false
      t.string :event_type, null: false
      t.timestamp :occurred_at, null: false
      t.references :lesson, index: true, null: false

      t.timestamps
    end
  end
end
