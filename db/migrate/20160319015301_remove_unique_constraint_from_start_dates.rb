class RemoveUniqueConstraintFromStartDates < ActiveRecord::Migration
  def change
    remove_index :participant_start_dates, :participant_id
    add_index :participant_start_dates, :participant_id
  end
end
