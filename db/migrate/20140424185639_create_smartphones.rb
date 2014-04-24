class CreateSmartphones < ActiveRecord::Migration
  def change
    create_table :smartphones do |t|
      t.string :number, null: false
      t.boolean :is_app_compatible, default: false
      t.references :participant, index: true, null: false
      t.boolean :is_owned_by_participant, default: false

      t.timestamps
    end
  end
end
