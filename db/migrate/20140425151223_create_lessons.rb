class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :title, null: false
      t.references :bit_core_slideshow, index: true
      t.integer :day_in_treatment, null: false, default: 1
      t.string :locale, null: false, default: "en"

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE lessons
            ADD CONSTRAINT fk_lessons_slideshows
            FOREIGN KEY (bit_core_slideshow_id)
            REFERENCES bit_core_slideshows(id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE lessons
            DROP CONSTRAINT IF EXISTS fk_lessons_slideshows
        SQL
      end
    end
  end
end
