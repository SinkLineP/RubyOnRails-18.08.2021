while true
print "(R)ock, (S)cissers, (P)aper? "
s = gets.strip.capitalize!


if s == "R" 
	user_choice = :rock
elsif s == "S"
	user_choice = :scissers
elsif s == "P"
	user_choice = :paper
else
	
	puts "Can't understand what you want, sorry..."
	exit	
end

arr = [:rock, :scissers, :paper]

computer_choice = arr[rand(0..2)]

if computer_choice == user_choice
	puts "Nobody wins"
end

end