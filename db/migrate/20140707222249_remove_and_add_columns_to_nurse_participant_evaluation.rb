class RemoveAndAddColumnsToNurseParticipantEvaluation < ActiveRecord::Migration
  def change
    remove_column :nurse_participant_evaluations, :smartphone_comfort
    remove_column :nurse_participant_evaluations, :participant_session_engagement
    remove_column :nurse_participant_evaluations, :app_usage_prediction
    add_column :nurse_participant_evaluations, :q1, :string
    add_column :nurse_participant_evaluations, :q2, :string
    add_column :nurse_participant_evaluations, :q3, :string
  end
end
