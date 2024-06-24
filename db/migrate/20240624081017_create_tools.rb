class CreateTools < ActiveRecord::Migration[7.0]
  def change
    create_table :tools do |t|
      t.string :name
      t.text :description
      t.string :short_name

      t.timestamps
    end
  end
end
