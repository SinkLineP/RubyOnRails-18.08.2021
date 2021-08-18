a = "rock"

b = "scissors"

c = "paper"

puts "enter simvol:" #это моя игра
m = gets.to_s.chomp!

#снизу игра компьютера
r = rand(0..2)

if r == 0
	puts a
elsif r == 1
	puts b
elsif r == 2
	puts c	
end
#до сюда

if m == r
	puts "nichya"




end
