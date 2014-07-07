class RemoveFirstAppointmentReferenceFromNurseParticipantEvaluation < ActiveRecord::Migration
  def change
    remove_column :nurse_participant_evaluations, :first_appointment_id
  end
end
