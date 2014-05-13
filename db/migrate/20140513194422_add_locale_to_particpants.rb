class AddLocaleToParticpants < ActiveRecord::Migration
  def change
    add_column :participants, :locale, :string
  end
end
