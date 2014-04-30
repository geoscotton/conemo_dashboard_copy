class UpdateContstraintsOnSmartphones < ActiveRecord::Migration
  def change
    change_column :smartphones, :is_smartphone_owner, :boolean, :default => false
  end
end
