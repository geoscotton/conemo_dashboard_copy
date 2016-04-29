class UpdateSupervisorNoteReference < ActiveRecord::Migration
  class MigrationSupervisorNote < ActiveRecord::Base
    self.table_name = :supervisor_notes
  end

  class MigrationParticipant < ActiveRecord::Base
    self.table_name = :participants
  end

  def change
    add_reference :supervisor_notes, :nurse

    MigrationSupervisorNote.find_each do |note|
      participant = MigrationParticipant.find(note.participant_id)
      note.update nurse_id: participant.nurse_id
    end

    remove_reference :supervisor_notes, :participant
  end
end
