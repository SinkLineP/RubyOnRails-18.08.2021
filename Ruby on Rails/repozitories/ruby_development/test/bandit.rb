m = 100 

puts "your balance: #{m}"
puts "enter start to game(or Ctrl + C)"
gets


while true
		r = rand(111..999)

	if r == 999
		puts "вам зачислено 50$"
		m + 50
		puts "Balance #{m}"

	end

	if r == 666
		puts "коммисия забрала -10$"
		m - 10
		puts "balance #{m}"
	
	end
	puts "--------#{r}--------"
	sleep 0.2
end