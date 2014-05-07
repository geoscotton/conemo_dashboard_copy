class CreatePatientContacts < ActiveRecord::Migration
  def change
    create_table :patient_contacts do |t|
      t.string :contact_reason
      t.text :note
      t.datetime :contact_at
      t.references :particpant, index: true

      t.timestamps
    end
  end
end
