class CreateScheduledTaskCancellations < ActiveRecord::Migration
  def change
    create_table :scheduled_task_cancellations do |t|
      t.references :nurse_task, foreign_key: true, null: false
      t.string :explanation, null: false

      t.timestamps null: false
    end

    add_index :scheduled_task_cancellations, :nurse_task_id, unique: true
  end
end
