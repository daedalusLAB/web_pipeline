class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.boolean :published
      t.integer :order

      t.timestamps
    end
  end
end
