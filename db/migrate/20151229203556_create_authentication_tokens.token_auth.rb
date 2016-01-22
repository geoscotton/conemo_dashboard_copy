# This migration comes from token_auth (originally 20150428211137)
class CreateAuthenticationTokens < ActiveRecord::Migration
  def change
    create_table :token_auth_authentication_tokens do |t|
      t.integer :entity_id, null: false
      t.string :value, null: false, limit: ::TokenAuth::AuthenticationToken::TOKEN_LENGTH
      t.boolean :is_enabled, null: false, default: true
      t.string :uuid, null: false, limit: ::TokenAuth::AuthenticationToken::UUID_LENGTH
      t.string :client_uuid, null: false
    end

    add_index :token_auth_authentication_tokens, :entity_id, unique: true
    add_index :token_auth_authentication_tokens, :value, unique: true
    add_index :token_auth_authentication_tokens, :client_uuid, unique: true
  end
end
