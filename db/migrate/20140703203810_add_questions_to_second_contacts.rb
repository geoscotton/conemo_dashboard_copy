class AddQuestionsToSecondContacts < ActiveRecord::Migration
  def change
    add_column :second_contacts, :q1, :text
    add_column :second_contacts, :q2, :boolean
    add_column :second_contacts, :q2_notes, :text
    add_column :second_contacts, :q3, :boolean
    add_column :second_contacts, :q3_notes, :text
    add_column :second_contacts, :q4, :boolean
    add_column :second_contacts, :q4_notes, :text
    add_column :second_contacts, :q5, :boolean
    add_column :second_contacts, :q5_notes, :text
    add_column :second_contacts, :q6, :boolean
    add_column :second_contacts, :q6_notes, :text
    add_column :second_contacts, :q7, :boolean
    add_column :second_contacts, :q7_notes, :text
  end
end
