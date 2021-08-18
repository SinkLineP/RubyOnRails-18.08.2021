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
artistk2 = []
alboms = []
alboms2 = []

	artists = Artist.new "Павло Зибров"
	artists2 = Artist.new "Сектор Газа"
		
		albomsk = Albom.new "Любов"
		albomsk2 = Albom.new "Пора домой"
		
	artistk << artists
	artistk2 << artists2
		
	alboms << albomsk
	alboms2 << albomsk2

	song1 = Song.new "марина любов моя едина", "3:11"
	song2 = Song.new "любимые женщины", "2:49"
	song3 = Song.new "like of live", "5:43"

		albomsk.add_song song1
		albomsk.add_song song2
		albomsk.add_song song3

	song1 = Song.new "бомж", "3:11"
	song2 = Song.new "ява", "2:49"
	song3 = Song.new "алкаш", "5:43"

		albomsk2.add_song song1
		albomsk2.add_song song2
		albomsk2.add_song song3

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

puts "=============================="
artistk2.each do |art|
	puts "#{art.artist}"
	alboms2.each do |alb|
		puts "Альбомы: #{alb.name}"
		alb.songin.each do |sog|
			puts "  Песня: #{sog.songs}, длительность: #{sog.duration}."
		end
	end
puts "=============================="
end
