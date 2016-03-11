class CreateLackOfConnectivityCalls < ActiveRecord::Migration
  def change
    create_table :lack_of_connectivity_calls do |t|
      t.references :participant, index: true, foreign_key: true, null: false
      t.datetime :contact_at, null: false
      t.string :explanation, null: false

      t.timestamps null: false
    end
  end
end
