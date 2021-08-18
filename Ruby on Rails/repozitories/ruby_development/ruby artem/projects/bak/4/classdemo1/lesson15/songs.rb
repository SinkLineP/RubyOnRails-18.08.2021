

class Album
  attr_reader :name, :songs

  def initialize(name)
    @name = name
    @songs = []
  end

  def add_song song
    @songs << song
  end

end

class Song
  attr_reader :name, :duration

  def initialize(name, duration)
    @name = name
    @duration = duration
  end

end

albums = []

abba = Album.new 'Abba'

albums << abba

song1 = Song.new "Foooo" , "1:44"
song2 = Song.new "Ba", "4:30"
song3 = Song.new "Yaoou", "2:32"

abba.add_song song1
abba.add_song song2
abba.add_song song3

albums.each do |album|
  puts "альбом: #{album.name}", ""
  album.songs.each do |song|
    puts "песни: #{song.name} -- длительность: #{song.duration}"
  end
end