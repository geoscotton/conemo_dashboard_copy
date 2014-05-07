class ChangeColumnNameOnPatientContacts < ActiveRecord::Migration
  def change
    add_reference :patient_contacts, :participant, index: true
    remove_reference :patient_contacts, :particpant
  end
end
