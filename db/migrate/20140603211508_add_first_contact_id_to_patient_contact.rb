class AddFirstContactIdToPatientContact < ActiveRecord::Migration
  def change
    add_reference :patient_contacts, :first_contact, index: true
  end
end
