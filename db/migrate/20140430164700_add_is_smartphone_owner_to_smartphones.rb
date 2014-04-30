class AddIsSmartphoneOwnerToSmartphones < ActiveRecord::Migration
  def change
    add_column :smartphones, :is_smartphone_owner, :boolean
  end
end
