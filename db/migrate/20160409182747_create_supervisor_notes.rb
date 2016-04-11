class CreateSupervisorNotes < ActiveRecord::Migration
  def change
    create_table :supervisor_notes do |t|
      t.text :note, null: false
      t.references :participant, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
