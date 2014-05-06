class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :content_access_event, index: true
      t.string :question
      t.string :name
      t.string :answer

      t.timestamps
    end
  end
end
