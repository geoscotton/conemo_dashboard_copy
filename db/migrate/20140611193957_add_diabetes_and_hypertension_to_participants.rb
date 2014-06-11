class AddDiabetesAndHypertensionToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :diabetes, :boolean, default: false
    add_column :participants, :hypertension, :boolean, default: false
  end
end
