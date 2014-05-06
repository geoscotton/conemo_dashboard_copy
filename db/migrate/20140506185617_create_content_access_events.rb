class CreateContentAccessEvents < ActiveRecord::Migration
  def change
    create_table :content_access_events do |t|
      t.references :content_release, index: true
      t.references :participant, index: true
      t.datetime :accessed_at

      t.timestamps
    end
  end
end
