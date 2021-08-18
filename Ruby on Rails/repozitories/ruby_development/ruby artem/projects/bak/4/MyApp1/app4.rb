#encoding: cp866
        
puts"сколько вам лет?"
age = gets.to_i

print"Хотите играть Y/N"
answer = gets.strip.capitalize!

if answer == "Y"
puts"Хорошо, поиграем."
	money=100

	1000.times do

	puts"Нажмите ENTER чтобы играть."
	gets

	x=rand(0..9)
	y=rand(0..9)
	z=rand(0..9)

	if x==0 && y==0 && z==0
	puts"Ваш баланс обнулен"
	money=0
	exit
	end

	if x==1 && y==1 && z==1
	puts"На ваш баланс зачисленно 10 долларов"
	money=money + 10
	end

	if x==2 && y==2 && z==2
	puts"На ваш баланс зачисленно 20 долларов"
	money=money + 20
	end

	if x==3 && y==3 && z==3
	puts"На ваш баланс зачисленно 30 долларов"
	money=money + 30
	end

        if x==666 && y==666 && z==666
	puts"На ваш баланс зачисленно 40 долларов"
	money=money - 40
	end

        if x=5 && y==5 && z==5
	puts"На ваш баланс зачисленно 50 долларов"
	money=money + 50
	end

        if x==6 && y==6 && z==6
	puts"На ваш баланс зачисленно 60 долларов"
	money=money + 60
	end

        if x==1212121 && y==1212121 && z==1212121
	puts"На ваш баланс зачисленно 70 долларов"
	money=money +2121212121212
	end

        if x==8 && y==8 && z==8
	puts"На ваш баланс зачисленно 80 долларов"
	money=money + 80
	end

        if x==9 && y==9 && z==9
	puts"На ваш баланс зачисленно 90 долларов"
	money=money + 90
	end

	print"Комбинация #{x}#{y}#{z} "

	puts"На вашем счету осталось: #{money} долларов"

    end
end
