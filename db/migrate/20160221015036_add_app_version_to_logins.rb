class AddAppVersionToLogins < ActiveRecord::Migration
  def change
    add_column :logins, :app_version, :string
  end
end
