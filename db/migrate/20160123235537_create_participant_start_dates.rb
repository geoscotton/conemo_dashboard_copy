class CreateParticipantStartDates < ActiveRecord::Migration
  def change
    create_table :participant_start_dates do |t|
      t.date :date, null: false
      t.string :uuid, null: false
      t.references :participant, foreign_key: true

      t.timestamps null: false
    end

    add_index :participant_start_dates, :participant_id, unique: true
  end
end
