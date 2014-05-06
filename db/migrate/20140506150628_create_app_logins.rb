class CreateAppLogins < ActiveRecord::Migration
  def change
    create_table :app_logins do |t|
      t.datetime :occurred_at
      t.references :participant, index: true

      t.timestamps
    end
  end
end
