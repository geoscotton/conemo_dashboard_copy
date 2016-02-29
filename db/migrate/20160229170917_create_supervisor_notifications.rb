class CreateSupervisorNotifications < ActiveRecord::Migration
  def change
    create_table :supervisor_notifications do |t|
      t.references :nurse, index: true, null: false
      t.references :nurse_supervisor, index: true, null: false
      t.references :nurse_task, index: true, foreign_key: true, null: false
      t.string :status, null: false, default: SupervisorNotification::STATUSES.active

      t.timestamps null: false
    end

    add_foreign_key :supervisor_notifications, :users, column: :nurse_id
    add_foreign_key :supervisor_notifications, :users, column: :nurse_supervisor_id
  end
end
