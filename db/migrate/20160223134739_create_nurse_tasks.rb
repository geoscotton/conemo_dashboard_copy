class CreateNurseTasks < ActiveRecord::Migration
  def change
    create_table :nurse_tasks do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :participant, index: true, foreign_key: true, null: false
      t.string :type, null: false
      t.string :status, null: false, default: NurseTask::STATUSES.active
      t.datetime :scheduled_at, null: false
      t.datetime :overdue_at, null: false

      t.timestamps null: false
    end
  end
end
