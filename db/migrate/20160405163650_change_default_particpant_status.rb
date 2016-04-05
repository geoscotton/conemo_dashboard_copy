class ChangeDefaultParticpantStatus < ActiveRecord::Migration
  def change
    change_column_default :participants, :status, Participant::UNASSIGNED
  end
end
