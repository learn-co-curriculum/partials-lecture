class CreateSongGenres < ActiveRecord::Migration
  def change
    create_table :song_genres do |t|
      t.references :song, index: true
      t.references :genre, index: true

      t.timestamps
    end
  end
end
