class AddConfirmationColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    User.reset_column_information

    User.all.each { |u| u.touch(:confirmed_at) }
  end
end
