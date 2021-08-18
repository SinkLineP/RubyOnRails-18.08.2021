require 'net/http'
require 'uri'

def podbor	
	input = File.open "Password.txt", "r"  

		while (@line = input.gets)
			@line.chomp
			@line
		end


	input.close
end

def wrong_pass? password
	uri = URI.parse 'http://localhost:4567'
	response = Net::HTTP.get(uri, :login => "admin", :password => password).body
	puts = response.include? "#{podbor}"
end

puts wrong_pass? "#{podbor}"
