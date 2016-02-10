class SetNurseType < ActiveRecord::Migration
  def change
    User.where(role: "nurse").each do |user|
      user.update type: "Nurse"
    end
  end
end
