class AddThirdContactReferencesToNurseParticipantEvaluation < ActiveRecord::Migration
  def change
    add_reference :nurse_participant_evaluations, :third_contact, index: true
  end
end
