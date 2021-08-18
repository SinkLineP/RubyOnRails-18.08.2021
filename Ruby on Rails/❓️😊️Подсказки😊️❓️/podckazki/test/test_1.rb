arr = []

while true

	

		print "Enter new product: "
			a = gets.chomp!

			if a == "stop" 
					puts '=================='
					break
				end

		print "Enter its price: "
			y =gets.chomp!


				
		arr <<[a, y]

end

x = 0 #определяет порядковый номер
arr.uniq do |item| #выбирает уникальные имена
	x += 1 # тоже самое что x = x + 1
	puts "#{x}. #{item[0]} - #{item[1]}grn"
    
end

