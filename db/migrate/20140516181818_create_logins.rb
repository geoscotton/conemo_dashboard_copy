class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.references :participant, index: true
      t.datetime :logged_in_at

      t.timestamps
    end
  end
end
