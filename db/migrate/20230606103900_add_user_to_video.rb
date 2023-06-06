class AddUserToVideo < ActiveRecord::Migration[7.0]
  def change
    add_reference :videos, :user, null: false, foreign_key: true
  end
end
