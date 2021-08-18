
add_10 = lambda { |x| x + 10  }
add_20 = lambda { |y| y + 20  }
sub_5 = lambda { |z| z - 5  }

balance = 1000

hash = {111 => add_10,
		222 => add_10,
		333 => add_20,
		444 => add_20,
		555 => add_20,
		666 => sub_5,
		777 => sub_5,
		888 => sub_5,
		999 => sub_5}

		puts "=========================="

loop do
			if balance < 0
				break
			end
	x = rand(100..999)
		
	puts "Combination: #{x}"

	if hash[x]
			f = hash[x]
			balance = f.call balance
			puts "lambda locate..."
	else
			balance = sub_5.call balance
	end
			
		puts "Your balance: #{balance}$"
		puts "=========================="
		sleep 0.2




end


