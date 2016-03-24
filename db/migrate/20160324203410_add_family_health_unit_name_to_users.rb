class AddFamilyHealthUnitNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :family_health_unit_name, :string
  end
end
