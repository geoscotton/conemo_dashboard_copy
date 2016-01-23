class AddUuidToHelpMessages < ActiveRecord::Migration
  def change
    add_column :help_messages, :uuid, :string
    HelpMessage.reset_column_information
    HelpMessage.all.each { |h| h.update(uuid: SecureRandom.uuid) }
    change_column_null :help_messages, :uuid, false
  end
end
