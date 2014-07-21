class CreateDialogues < ActiveRecord::Migration
  def change
    create_table :dialogues do |t|
      t.references :lesson, index: true
      t.string :title

      t.timestamps
    end
  end
end
