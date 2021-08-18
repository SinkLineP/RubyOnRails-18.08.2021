# encoding: cp866


print "Сколько раз будем играть: "

nanno = gets.to_i

nanno.times do  |x|

	puts "Игра: #{x+1}"

	print"Введите число: "

	num = gets.to_i

	x = rand(1..3)

	if x == num
		puts "вы угадали"
		puts "============="
	else
		puts "вы проиграли"
		puts "============="	
	end
end
