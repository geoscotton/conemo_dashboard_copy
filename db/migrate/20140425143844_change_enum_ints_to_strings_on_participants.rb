class ChangeEnumIntsToStringsOnParticipants < ActiveRecord::Migration
  def change
    change_column :participants, :gender, :string
    change_column :participants, :key_chronic_disorder, :string, null: false
    change_column :participants, :status, :string, default: "pending"
  end
end
