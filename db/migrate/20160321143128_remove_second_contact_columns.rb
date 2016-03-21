class RemoveSecondContactColumns < ActiveRecord::Migration
  def change
    remove_column :second_contacts, :q1, :text
    remove_column :second_contacts, :q2, :boolean
    remove_column :second_contacts, :q2_notes, :text
    remove_column :second_contacts, :q3, :boolean
    remove_column :second_contacts, :q3_notes, :text
    remove_column :second_contacts, :q4, :boolean
    remove_column :second_contacts, :q4_notes, :text
    remove_column :second_contacts, :q5, :boolean
    remove_column :second_contacts, :q5_notes, :text
    remove_column :second_contacts, :q6, :boolean
    remove_column :second_contacts, :q6_notes, :text
    remove_column :second_contacts, :q7, :boolean
    remove_column :second_contacts, :q7_notes, :text
  end
end
