class CreateToolDependencies < ActiveRecord::Migration[7.0]
  def change
    create_table :tool_dependencies do |t|
      t.references :tool, null: false, foreign_key: true
      t.references :depends_on, null: false, foreign_key:  { to_table: :tools }

      t.timestamps
    end
  end
end
