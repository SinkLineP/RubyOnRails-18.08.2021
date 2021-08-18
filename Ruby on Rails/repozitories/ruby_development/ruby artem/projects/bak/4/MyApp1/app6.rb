#encoding: cp866



x = rand(1..100)

m = 10

1.upto(m) do |n|


	print"Я загадал число угадай какое? Попытка №#{n}, осталось попыток #{m - n + 1} :  "

	y = gets.to_i

		if y == x
			puts"Ура, молодец!"
			exit
		elsif y > x
			puts"Нет, меньше!"  
		elsif y < x
			puts"Нет, больше!"  
		end

	if y > 100
		exit
	end
      	
end