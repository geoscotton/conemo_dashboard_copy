# This migration comes from token_auth (originally 20151229184253)
class CreateTokenAuthSynchronizableResources < ActiveRecord::Migration
  def change
    create_table :token_auth_synchronizable_resources do |t|
      t.string :uuid, null: false
      t.integer :entity_id, null: false
      t.string :entity_id_attribute_name, null: false
      t.string :name, null: false
      t.string :class_name, null: false
      t.boolean :is_pullable, default: false, null: false
      t.boolean :is_pushable, default: false, null: false

      t.timestamps null: false
    end
  end
end
