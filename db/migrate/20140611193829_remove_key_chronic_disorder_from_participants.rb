class RemoveKeyChronicDisorderFromParticipants < ActiveRecord::Migration
  def change
    remove_column :participants, :key_chronic_disorder
  end
end
