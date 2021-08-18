#arr = []
=begin
a ="rocks" #камень
b ="scissers" #ножницы
c ="paper" #бумага
#=======================
=end



puts "--------------------------------"
puts "Enter simvol (serial number) "
puts "--------------------------------"
sleep (0.4)
puts "1.rocks"
puts "--------------------------------"
sleep (0.4)
puts "2.scissers"
puts "--------------------------------"
sleep (0.4)
puts "3.paper"
puts "--------------------------------"


while true

	print "Enter simvol: "
		a = gets.to_i #человек

		if a == 1 
			puts "you enter rocks"
		elsif a == 2
			puts "you enter scissers"
		elsif a == 3
			puts "you enter paper"
		end
	puts "-----------------------------"
		h = rand (1..3) #компьютер


		if h == 1
			puts "Computer"
			puts "rocks"
			puts "========================="
		elsif h == 2
			puts "Computer"
			puts "scissers"
			puts "========================="
		elsif h == 3
			puts "Computer"
			puts "paper"
			puts "========================="
		end
			if a == h
				puts "nechiya"
				puts "========================="
			elsif a > h
				puts"you winner"
				puts "========================="
			elsif a < h 
				puts "winner computer"
				puts "========================="
			end
			sleep (0.4)

			puts "You want next game (Y/N) "
			puts "========================="
			n = gets.chomp!.capitalize
			puts "=========================" 

				if n == "Y"
					
					puts "Go run game"
					puts "========================="
				end

				if n == "N"
					
					puts "Good buy"
					puts "========================="
					exit
				end
end