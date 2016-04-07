class CreateScheduledTaskReschedulings < ActiveRecord::Migration
  def change
    create_table :scheduled_task_reschedulings do |t|
      t.references :nurse_task, index: true, foreign_key: true, null: false
      t.string :explanation, null: false
      t.datetime :old_scheduled_at, null: false
      t.datetime :scheduled_at, null: false
      t.text :notes

      t.timestamps null: false
    end
  end
end
