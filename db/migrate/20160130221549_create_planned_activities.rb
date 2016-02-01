class CreatePlannedActivities < ActiveRecord::Migration
  def change
    create_table :planned_activities do |t|
      t.string :uuid, null: false
      t.references :participant, null: false
      t.string :name, null: false
      t.boolean :is_complete
      t.boolean :is_help_wanted
      t.string :level_of_happiness
      t.string :how_worthwhile
      t.datetime :planned_at, null: false
      t.string :lesson_guid, null: false

      t.timestamps null: false
    end
  end
end
