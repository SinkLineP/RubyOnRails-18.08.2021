while true
	tim = sleep 0.4


	puts "Здравствуйте, я Тика"
	tim
	print "Что вы хотите? "
	tim
	puts "
1.Рандомное число
"
	print "Выберите номер: "

	x = gets.to_i





	def one 
		puts "Bам нужно Рандомное число, выберите параметр."
		puts "1 до 10"
		puts "1 до 20"
		puts "1 до 30"
		puts "1 до 40"
		puts "1 до 50"
		puts "1 до 60"
		puts "1 до 70"
		puts "1 до 80"
		puts "1 до 90"
		puts "1 до 100"
		puts "свой параметр"
		print "Введите параметр: "

			y = gets.chomp!

			if y == "1 до 10"
				puts rand(1..10)
			end

			if y == "1 до 20"
				puts rand(1..20)
			end

			if y == "1 до 30"
				puts rand(1..30)
			end

			if y == "1 до 40"
				puts rand(1..40)
			end

			if y == "1 до 50"
				puts rand(1..50)
			end

			if y == "1 до 60"
				puts rand(1..50)
			end

			if y == "1 до 70"
				puts rand(1..50)
			end

			if y == "1 до 80"
				puts rand(1..50)
			end

			if y == "1 до 90"
				puts rand(1..50)
			end

			if y == "1 до 100"
				puts rand(1..50)
			end

			if y == "свой параметр"
				print "Введите первое число: "
				a = gets.to_i
				print "Введите второе число: "
				b = gets.to_i
					puts rand(a..b)
			end
	end

	while true
		if x == 1

			puts one
	end

	


end

