class Song
	attr_accessor :name
	attr_accessor :duration

		def initialize name, duration
			@name = name
			@duration = duration
		end

end

song1 = Song.new 'The show must go on', 6
puts "----------------------------------------------"
puts "Song: #{song1.name}, time: #{song1.duration}"
puts "----------------------------------------------"