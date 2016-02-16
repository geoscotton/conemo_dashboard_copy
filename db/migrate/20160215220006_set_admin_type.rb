class SetAdminType < ActiveRecord::Migration
  def change
    User.where(role: "admin").each do |user|
      user.update type: "Admin"
    end
  end
end
