class UpdateUsersTimezoneNotNull < ActiveRecord::Migration
  def change
    change_column_null :users, :timezone, false
  end
end
