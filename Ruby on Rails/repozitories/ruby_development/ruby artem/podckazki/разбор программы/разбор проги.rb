# encoding: cp1251

print "Сколько вам лет? " 	#выводит вопрос
age = gets.to_i	  #В "age" мы вводим на возраст

print "Хотите играть? (Y/N) " #выводит вопрос на который мы можем ответить "(Y/N)" 
answer = gets.strip.capitalize 

if answer == "Y" && age >= 18
	puts "Хорошо, поиграем!"

	money = 100
	
	add_money_proc = lambda { |sum, money|
		puts "Вам зачислено #{sum} долларов"
		money + sum
	}
	
	sub_money_proc = lambda { |sum, money|
		puts "Вы потеряли #{sum} долларов"
		money - sum
	}
	
	actions =
	{
		"000" => lambda { |money|
				puts "Ваш баланс обнулен!"
				0
		},
		"111" => [10, add_money_proc],
		"222" => [20, add_money_proc],
		"333" => [30, add_money_proc],
		"444" => [40, add_money_proc],
		"555" => [50, add_money_proc],
		"666" => lambda { |money|
				puts "Вы потеряли половину суммы"
				money / 2
		},
		"777" => [70, sub_money_proc],
		"888" => [80, sub_money_proc],
		"999" => [90, sub_money_proc],
		"123" => [123, sub_money_proc],
	}

	1000.times do

		puts "Введите Enter чтобы дернуть ручку"
		gets

		num = rand(0..9).to_s + rand(0..9).to_s + rand(0..9).to_s

		puts "Выпало #{num}"
		
		if actions.has_key?(num)
			if actions[num].is_a?(Array)
				money = actions[num][1].call(actions[num][0], money)
			elsif actions[num].is_a?(Proc)
				money = actions[num].call(money)
			end
		end

		puts "Осталось денег: #{money} долларов"
		
		if money == 0
			puts "У вас не осталось денег"
			break
		elsif money < 0
			puts "Вы продали всё свое имущество, чтобы расплатиться и покончили с собой"
		end
	end
end