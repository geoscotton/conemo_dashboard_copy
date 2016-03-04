class ModifySmartphoneColumns < ActiveRecord::Migration
  def change
    remove_column :smartphones, :is_app_compatible
    remove_column :smartphones, :is_owned_by_participant
    remove_column :smartphones, :is_smartphone_owner
    add_column :smartphones, :phone_identifier, :string, null: false, default: "?"
  end
end
