class AddParticipantReferenceToFinalAppointment < ActiveRecord::Migration
  def change
    add_column :final_appointments, :participant_id, :integer
  end
end
