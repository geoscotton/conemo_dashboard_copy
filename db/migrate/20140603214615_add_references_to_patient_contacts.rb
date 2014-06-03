class AddReferencesToPatientContacts < ActiveRecord::Migration
  def change
    add_reference :patient_contacts, :first_appointment, index: true
    add_reference :patient_contacts, :second_contact, index: true
  end
end
