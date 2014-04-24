class AddConstraints < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE participants
            ADD CONSTRAINT fk_participants_nurses
            FOREIGN KEY (nurse_id)
            REFERENCES users(id)
        SQL
        execute <<-SQL
          ALTER TABLE smartphones
            ADD CONSTRAINT fk_smartphones_participants
            FOREIGN KEY (participant_id)
            REFERENCES participants(id)
        SQL
        execute <<-SQL
          ALTER TABLE first_contacts
            ADD CONSTRAINT fk_first_contacts_participants
            FOREIGN KEY (participant_id)
            REFERENCES participants(id)
        SQL
        execute <<-SQL
          ALTER TABLE first_appointments
            ADD CONSTRAINT fk_first_appointments_participants
            FOREIGN KEY (participant_id)
            REFERENCES participants(id)
        SQL
        execute <<-SQL
          ALTER TABLE second_contacts
            ADD CONSTRAINT fk_second_contacts_participants
            FOREIGN KEY (participant_id)
            REFERENCES participants(id)
        SQL
        execute <<-SQL
          ALTER TABLE nurse_participant_evaluations
            ADD CONSTRAINT fk_evaluations_first_appointments
            FOREIGN KEY (first_appointment_id)
            REFERENCES first_appointments(id)
        SQL
        execute <<-SQL
          ALTER TABLE nurse_participant_evaluations
            ADD CONSTRAINT fk_evaluations_second_contacts
            FOREIGN KEY (second_contact_id)
            REFERENCES second_contacts(id)
        SQL
        execute <<-SQL
          ALTER TABLE reminder_messages
            ADD CONSTRAINT fk_reminder_messages_nurses
            FOREIGN KEY (nurse_id)
            REFERENCES users(id)
        SQL
        execute <<-SQL
          ALTER TABLE reminder_messages
            ADD CONSTRAINT fk_reminder_messages_participants
            FOREIGN KEY (participant_id)
            REFERENCES participants(id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE reminder_messages
            DROP CONSTRAINT IF EXISTS fk_reminder_messages_participants
        SQL
        execute <<-SQL
          ALTER TABLE reminder_messages
            DROP CONSTRAINT IF EXISTS fk_reminder_messages_nurses
        SQL
        execute <<-SQL
          ALTER TABLE nurse_participant_evaluations
            DROP CONSTRAINT IF EXISTS fk_evaluations_second_contacts
        SQL
        execute <<-SQL
          ALTER TABLE nurse_participant_evaluations
            DROP CONSTRAINT IF EXISTS fk_evaluations_first_appointments
        SQL
        execute <<-SQL
          ALTER TABLE second_contacts
            DROP CONSTRAINT IF EXISTS fk_second_contacts_participants
        SQL
        execute <<-SQL
          ALTER TABLE first_appointments
            DROP CONSTRAINT IF EXISTS fk_first_appointments_participants
        SQL
        execute <<-SQL
          ALTER TABLE first_contacts
            DROP CONSTRAINT IF EXISTS fk_first_contacts_participants
        SQL
        execute <<-SQL
          ALTER TABLE smartphones
            DROP CONSTRAINT IF EXISTS fk_smartphones_participants
        SQL
        execute <<-SQL
          ALTER TABLE participants
            DROP CONSTRAINT IF EXISTS fk_participants_nurses
        SQL
      end
    end
  end
end
