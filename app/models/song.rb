class Song < ActiveRecord::Base
  belongs_to :artist

  def artist_name=(artist_name)
    # Deprecated
    # self.artist = Artist.find_or_create_by_name(artist_name)
    
    # Avi likes these two
    self.artist = Artist.first_or_create(:name => artist_name)
    # self.artist = Artist.find_or_create_by(:name => artist_name)

    # Avi Doesn't Like This
    # self.artist = Artist.where(:name => artist_name).first_or_create
  end

end