class UpdateSupervisorNoteReference < ActiveRecord::Migration
  class MigrationSupervisorNote < ActiveRecord::Base
    self.table_name = :supervisor_notes
  end

  def change
    add_reference :supervisor_notes, :nurse

    MigrationSupervisorNote.find_each do |note|
      note.update nurse: note.participant.nurse
    end

    remove_reference :supervisor_notes, :participant
  end
end
