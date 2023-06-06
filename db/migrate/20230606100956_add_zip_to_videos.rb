class AddZipToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :zip, :string
  end
end
