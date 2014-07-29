class CreateDialogues < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? :dialogues
      drop_table :dialogues
    end
    
    create_table :dialogues do |t|
      t.string :title
      t.string :guid
      t.string :day_in_treatment
      t.string :locale
      t.text :message
      t.text :yes_text
      t.text :no_text

      t.timestamps
    end
  end
end
