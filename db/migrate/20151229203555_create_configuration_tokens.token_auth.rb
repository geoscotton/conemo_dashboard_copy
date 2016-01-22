# This migration comes from token_auth (originally 20150428210721)
class CreateConfigurationTokens < ActiveRecord::Migration
  def change
    create_table :token_auth_configuration_tokens do |t|
      t.datetime :expires_at, null: false
      t.string :value, null: false
      t.integer :entity_id, null: false
    end

    add_index :token_auth_configuration_tokens, :entity_id, unique: true
  end
end
