class Artist
	attr_reader :artist
	def initialize artist
		@artist = artist
	end

end

class Albom
	attr_reader :name, :songin
	def initialize(name)
		@name = name
		@songin = []
	end

	def add_song song
		@songin << song
	end
end

class Song
	attr_reader :songs, :duration

	def initialize (songs, duration)
		@songs = songs
		@duration = duration
	end
end

artistk = []
alboms = []

	artists = Artist.new "Павло Зибров"
		
		albomsk = Albom.new "Любов"
	artistk << artists
		
	alboms << albomsk

	song1 = Song.new "марина любов моя едина", "3:11"
	song2 = Song.new "любимые женщины", "2:49"
	song3 = Song.new "like of live", "5:43"

		albomsk.add_song song1
		albomsk.add_song song2
		albomsk.add_song song3

puts "=============================="
artistk.each do |art|
	puts "#{art.artist}"
	alboms.each do |alb|
		puts "Альбомы: #{alb.name}"
		alb.songin.each do |sog|
			puts "  Песня: #{sog.songs}, длительность: #{sog.duration}."
		end
	end
puts "=============================="
end
