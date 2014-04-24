class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.references :nurse, index: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :study_identifier, null: false
      t.string :family_health_unit_name, null: false
      t.string :family_record_number, null: false
      t.string :phone, null: false
      t.string :secondary_phone
      t.string :email
      t.text :address
      t.date :date_of_birth
      t.integer :gender
      t.integer :key_chronic_disorder, null: false
      t.date :enrollment_date, null: false
      t.integer :status, default: 0
      t.string :emergency_contact_name
      t.string :emergency_contact_phone

      t.timestamps
    end
  end
end
