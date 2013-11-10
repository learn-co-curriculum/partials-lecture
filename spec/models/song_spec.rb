require 'spec_helper'

describe Song do
  context 'with artists' do
    describe '#artist_name=' do
      it 'creates a new artist and assigns it by name' do
        song = Song.new
        song.artist_name = "Michael Jackson"
        song.save

        expect(song.artist.name).to eq("Michael Jackson")
      end

      it 'assigns an existing artist by name' do
        artist = Artist.create(:name => "Bob Dylan")

        song = Song.new
        song.artist_name = artist.name
        song.save

        expect(song.artist.name).to eq(artist.name)
      end

    end
  end

  context "with genres" do
    describe "#genre_names=" do
      it "accepts a CSV string of genre names and adds them" do
        song = Song.new
        song.genre_names = "pop, rock, jazz"
        song.save

        expect(song.genres.size).to eq(3)
      end
    end

    describe '#add_genre' do
      it 'builds the associated song_genre to add the genre' do
        song = Song.new
        song.add_genre(Genre.create(:name => "pop"))
        song.save

        expect(song.song_genres.first.genre).to eq(Genre.find_by(:name => "pop"))
      end
    end
  end
end
