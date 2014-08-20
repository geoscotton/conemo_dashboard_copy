class AddQuestionsToThirdContact < ActiveRecord::Migration
  def change
    add_column :third_contacts, :q1, :text
    add_column :third_contacts, :q2, :boolean
    add_column :third_contacts, :q2_notes, :text
    add_column :third_contacts, :q3, :boolean
    add_column :third_contacts, :q3_notes, :text
    add_column :third_contacts, :q4, :boolean
    add_column :third_contacts, :q4_notes, :text
    add_column :third_contacts, :q5, :boolean
    add_column :third_contacts, :q5_notes, :text
  end
end
