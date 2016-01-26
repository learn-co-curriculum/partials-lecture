require 'feature_helper'

feature "CRUD for Songs" do

  context 'creating a new song' do
    scenario 'loading the new song form' do
      visit '/songs/new'
      page.should have_css("form#new_song")
    end

    scenario 'creating a song' do
      visit '/songs/new'
      
      within 'form#new_song' do
        fill_in 'song[name]', :with => "Billie Jean"
        fill_in 'song[artist_name]', :with => "Michael Jackson"
        fill_in 'song[genre_names]', :with => "pop, dance"

        click_button 'Create Song'
      end

      page.should have_content("Billie Jean")
      page.should have_content("Michael Jackson")
      page.should have_content("pop")
      page.should have_content("dance")
    end
  end

  context "showing a song" do
    given!(:song){Song.create(:name => "Billie Jean", :artist_name => "Michael Jackson", :genre_names => "pop, dance")}
    
    scenario "loads a song" do
      visit song_path(song)

      page.should have_content("Billie Jean")
      page.should have_content("Michael Jackson")
      page.should have_content("pop")
      page.should have_content("dance")
    end
  end
end