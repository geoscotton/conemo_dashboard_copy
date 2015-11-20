class UpdateResponses < ActiveRecord::Migration
  def change
    remove_column :responses, :question, :string
    change_column_null :responses, :answer, false
  end
end
