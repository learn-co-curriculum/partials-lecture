class AddArtistIdToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :artist_id, :integer
    add_index :songs, :artist_id
  end


end
