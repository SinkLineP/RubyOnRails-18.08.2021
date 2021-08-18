hh = {5 => 10, 10 => 4, 13 => 250, 3 => 10, 30 => 10}


balanse = 100


while true
		
			b = rand(1..30)
		
				if hh[b]
					balanse = balanse + hh[b]
				else 
					balanse = balanse - 20
				end

				if balanse < -0
					break
				end

				puts "combination #{b}"
				puts ""
				puts "your balanse: #{balanse}$"
				puts "----------------------------"


 	sleep (1)			
end	
