class UpdateParticipantsTable < ActiveRecord::Migration
  def change
    remove_column :participants, :diabetes, :boolean
    remove_column :participants, :email, :string
    remove_column :participants, :family_record_number, :string
    remove_column :participants, :hypertension, :boolean
    remove_column :participants, :start_date, :date
    add_column :participants, :alternate_phone_1, :string
    add_column :participants, :alternate_phone_2, :string
    add_column :participants, :contact_person_1_name, :string
    add_column :participants, :contact_person_1_relationship, :string
    add_column :participants, :contact_person_1_other_relationship, :string
    add_column :participants, :contact_person_2_name, :string
    add_column :participants, :contact_person_2_relationship, :string
    add_column :participants, :contact_person_2_other_relationship, :string
    add_column :participants, :emergency_contact_relationship, :string
    add_column :participants, :emergency_contact_other_relationship, :string
    add_column :participants, :emergency_contact_address, :string
    add_column :participants, :emergency_contact_cell_phone, :string
    add_column :participants, :cell_phone, :string
    change_column_null :participants, :address, false
    change_column_null :participants, :gender, false
    change_column_null :participants, :locale, false
    change_column_null :participants, :phone, true
    change_column_null :participants, :status, false
  end
end
