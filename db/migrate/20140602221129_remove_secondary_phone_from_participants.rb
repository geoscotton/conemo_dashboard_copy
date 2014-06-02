class RemoveSecondaryPhoneFromParticipants < ActiveRecord::Migration
  def change
    remove_column :participants, :secondary_phone
  end
end
