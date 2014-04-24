class CreateNurseParticipantEvaluations < ActiveRecord::Migration
  def change
    create_table :nurse_participant_evaluations do |t|
      t.references :first_appointment, index: true
      t.references :second_contact, index: true
      t.integer :smartphone_comfort, null: false
      t.integer :participant_session_engagement, null: false
      t.integer :app_usage_prediction, null: false

      t.timestamps
    end
  end
end
