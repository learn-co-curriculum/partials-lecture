class Genre < ActiveRecord::Base
  has_many :song_genres
  has_many :songs, :through => :song_genres

  def self.find_or_create_by_csv_string(csv_string)
    genre_names = csv_string.split(",").collect{|g| g.strip.downcase}
    genre_names.collect do |genre_name|
      Genre.find_or_create_by(:name => genre_name)
    end
  end
  
end
