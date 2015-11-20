class UpdateSessionEvents < ActiveRecord::Migration
  def change
    add_foreign_key :session_events, :participants
    add_foreign_key :session_events, :lessons
  end
end
