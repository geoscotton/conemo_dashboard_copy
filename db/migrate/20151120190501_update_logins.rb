class UpdateLogins < ActiveRecord::Migration
  def change
    change_column_null :logins, :participant_id, false
    change_column_null :logins, :logged_in_at, false
    add_foreign_key :logins, :participants
  end
end
