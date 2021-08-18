	@a1 = " "
	@a2 = " "
	@a3 = " "
	@b1 = " "
	@b2 = " "
	@b3 = " "
	@c1 = " "
	@c2 = " "
	@c3 = " "



def grid
		puts "
		      1         2        3
		 +---------+--------+--------+
		 |         |        |        |
		 |         |        |        |
		A|    #{@a1}    |   #{@a2}    |   #{@a3}    |
		 |         |        |        |
		 |         |        |        |
		 +---------+--------+--------+
		 |         |        |        |
		 |         |        |        |
		B|    #{@b1}    |   #{@b2}    |    #{@b3}   |
		 |         |        |        |
		 |         |        |        | 
		 +---------+--------+--------+
		 |         |        |        |
		 |         |        |        |   
		C|    #{@c1}    |   #{@c2}    |    #{@c3}   |
		 |         |        |        |
		 |         |        |        |
		 +---------+--------+--------+
		"
end




	
		
	while  true
	    puts grid
		puts "Пример ввода (a1, b2, c3)."
		puts "Первый игрок 'X'"
		print "Введите ячейку: "
		
		while true
			@a = gets.chomp!

			
		    if @a == "a1" && @a1 == " "
				@a1 = "X" 
				break
			elsif @a == "a2" && @a2 == " "
				@a2 = "X"
				break
			elsif @a == "a3" && @a3 == " "
				@a3 = "X"
				break
			elsif @a == "b1" && @b1 == " "
				@b1 = "X"
				break 
			elsif @a == "b2" && @b2 == " "
				@b2 = "X"
				break
			elsif @a == "b3" && @b3 == " "
				@b3 = "X"
				break
			elsif @a == "c1" && @c1 == " "
				@c1 = "X"
				break
			elsif @a == "c2" && @c2 == " "
				@c2 = "X" 
				break
			elsif @a == "c3" && @c3 == " "
				@c3 = "X"
				break
			else
				puts "Выберите другую ячейку: "			
			end
	   	end
				puts grid

		
			if @a1 == "X" && @a2 == "X" && @a3 == "X"
				puts "Выиграл игрок 'X'"
				break
			elsif @b1 == "X" && @b2 == "X" && @b3 == "X"
				puts "Выиграл игрок 'X'"
				break
			elsif @c1 == "X" && @c2 == "X" && @c3 == "X"
				puts "Выиграл игрок 'X'"
				break
			elsif @a1 == "X" && @b2 == "X" && @c3 == "X"
				puts "Выиграл игрок 'X'"
				break
			elsif @a3 == "X" && @b2 == "X" && @c1 == "X"
				puts "Выиграл игрок 'X'"
				break
			elsif @a1 == "X" && @b1 == "X" && @c1 == "X"
				puts "Выиграл игрок 'X'"
				break
			elsif @a2 == "X" && @b2 == "X" && @c2 == "X"
				puts "Выиграл игрок 'X'"
				break
			elsif @a3 == "X" && @b3 == "X" && @c3 == "X"
				puts "Выиграл игрок 'X'"
				break
			end

			if @a1 != " " && @a2 != " " && @a3 != " " && @b1 != " " && @b2 != " " && @b3 != " " && @c1 != " " && @c2 != " " && @c3 != " "
				puts"Ничья!!!"
				@a1 = " "
				@a2 = " " 
				@a3 = " "
				@b1 = " "
				@b2 = " "
				@b3 = " "
				@c1 = " "
				@c2 = " "
				@c3	= " "
					puts "Хотиет ли вы продолжить игру (Y/N)"
					@var = gets.chomp!
						if @var == "Y"
							puts "        ==================       "
							puts grid
						else 
							puts "Хорошая игра была!!!"
							puts "Удачи, будем ждать ещё!"
							exit
						end
			end




		puts "Второй игрок 'O'"
		print "Введите ячейку: "
		

		
		while true
			@z = gets.chomp!

		    if @z == "a1" && @a1 == " "
				@a1 = "O" 
				break
			elsif @z == "a2" && @a2 == " "
				@a2 = "O"
				break
			elsif @z == "a3" && @a3 == " "
				@a3 = "O"
				break
			elsif @z == "b1" && @b1 == " "
				@b1 = "O"
				break 
			elsif @z == "b2" && @b2 == " "
				@b2 = "O"
				break
			elsif @z == "b3" && @b3 == " "
				@b3 = "O"
				break
			elsif @z == "c1" && @c1 == " "
				@c1 = "O"
				break
			elsif @z == "c2" && @c2 == " "
				@c2 = "O"
				break
			elsif @z == "c3" && @c3 == " "
				@c3 = "O"
				break
			else
				puts "Выберите другую ячейку: "			
			end
		end

			puts grid

		if @a1 == "O" && @a2 == "O" && @a3 == "O"
			puts "Выиграл игрок 'O'"
			break
		elsif @b1 == "O" && @b2 == "O" && @b3 == "O"
			puts "Выиграл игрок 'O'"
			break
		elsif @c1 == "O" && @c2 == "O" && @c3 == "O"
			puts "Выиграл игрок 'O'"
			break
		elsif @a1 == "O" && @b2 == "O" && @c3 == "O"
			puts "Выиграл игрок 'O'"
			break
		elsif @a3 == "O" && @b2 == "O" && @c1 == "O"
			puts "Выиграл игрок 'O'"
			break
		elsif @a1 == "O" && @b1 == "O" && @c1 == "O"
			puts "Выиграл игрок 'O'"
			break
		elsif @a2 == "O" && @b2 == "O" && @c2 == "O"
			puts "Выиграл игрок 'O'"
		    break
		elsif @a3 == "O" && @b3 == "O" && @c3 == "O"
			puts "Выиграл игрок 'O'"
			break	
		end

		if @a1 != " " && @a2 != " " && @a3 != " " && @b1 != " " && @b2 != " " && @b3 != " " && @c1 != " " && @c2 != " " && @c3 != " "
				puts"Ничья!!!"
				@a1 = " "
				@a2 = " " 
				@a3 = " "
				@b1 = " "
				@b2 = " "
				@b3 = " "
				@c1 = " "
				@c2 = " "
				@c3	= " "
					puts "Хотиет ли вы продолжить игру (Y/N)"
					@var = gets.chomp!
						if @var == "Y"
							puts "        ==================       "
							puts grid
						else
							puts "Хорошая игра была!!!" 
							puts "Удачи, будем ждать ещё!"
							exit
						end
		end
	end		