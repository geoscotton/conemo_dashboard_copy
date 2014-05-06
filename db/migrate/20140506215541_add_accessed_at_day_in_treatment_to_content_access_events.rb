class AddAccessedAtDayInTreatmentToContentAccessEvents < ActiveRecord::Migration
  def change
    add_column :content_access_events, :day_in_treatment_accessed, :integer
  end
end
