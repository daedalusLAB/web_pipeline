class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :full_name, :string
    add_column :users, :company, :string
    add_column :users, :invited_by, :string
  end
end
