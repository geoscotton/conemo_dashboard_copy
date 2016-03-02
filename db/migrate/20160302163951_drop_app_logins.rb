class DropAppLogins < ActiveRecord::Migration
  def change
    drop_table :app_logins
  end
end
