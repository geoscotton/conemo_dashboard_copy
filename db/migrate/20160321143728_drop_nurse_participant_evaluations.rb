class DropNurseParticipantEvaluations < ActiveRecord::Migration
  def change
    drop_table :nurse_participant_evaluations
  end
end
