class RemoveSmartphoneDefault < ActiveRecord::Migration
  def change
    change_column_default :smartphones, :phone_identifier, nil
  end
end
