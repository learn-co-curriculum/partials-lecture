require 'feature_helper'

feature "CRUD for Songs" do

  context 'creating a new song' do
    scenario 'loading the new song form' do
      visit '/songs/new'
      page.should have_css("form#new_song")
    end

    scenario 'assigning an artist by name to a song' do
      visit '/songs/new'
      
      within 'form#new_song' do
        fill_in 'song[name]', :with => "Billie Jean"
        fill_in 'song[artist_name]', :with => "Michael Jackson"
        click_button 'Create Song'
      end

      page.should have_content("Billie Jean")
      page.should have_content("Michael Jackson")
    end
  end

end