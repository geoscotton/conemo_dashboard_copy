class AddUuidToLogins < ActiveRecord::Migration
  def change
    add_column :logins, :uuid, :string
    Login.reset_column_information
    Login.all.each { |h| h.update(uuid: SecureRandom.uuid) }
    change_column_null :logins, :uuid, false
  end
end
