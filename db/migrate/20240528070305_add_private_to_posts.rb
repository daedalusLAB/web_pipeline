class AddPrivateToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :private, :boolean, default: false, null: false
  end
end
