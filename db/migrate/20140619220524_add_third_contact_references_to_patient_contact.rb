class AddThirdContactReferencesToPatientContact < ActiveRecord::Migration
  def change
    add_reference :patient_contacts, :third_contact, index: true
  end
end
