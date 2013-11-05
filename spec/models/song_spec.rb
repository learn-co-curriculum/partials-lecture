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
end
