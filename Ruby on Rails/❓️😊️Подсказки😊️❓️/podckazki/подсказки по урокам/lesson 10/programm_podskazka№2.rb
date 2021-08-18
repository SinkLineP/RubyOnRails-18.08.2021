arr = []

while true

	

		print "enter your name: "
			a = gets.chomp!

			if a == "stop" 
					puts '=================='
					break
				end

		print "enter you age: "
			y =gets.chomp!


				
		arr <<[a, y]

end

x = 0 #определяет порядковый номер
arr.uniq do |people| #выбирает уникальные имена
	x += 1 # тоже самое что x = x + 1
	puts "#{x}. #{people[0]} #{people[1]}"

end


