class RemoveEnrollmentDateFromParticipants < ActiveRecord::Migration
  def change
    remove_column :participants, :enrollment_date
  end
end
