class AddAppLoginGuidToLogin < ActiveRecord::Migration
  def change
    add_column :logins, :app_login_guid, :string
  end
end
