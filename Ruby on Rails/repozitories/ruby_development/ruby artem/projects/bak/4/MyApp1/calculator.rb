#encoding: cp866

puts"Введите число А: "
a = gets.to_f
puts"Введите число B: "
b = gets.to_f

puts"выберите знак (+_-_*_/)"
znak=gets.strip

result= 0

if znak  == "+"
	result = a + b	
end

if znak  == "-"
	result = a - b	
end

if znak  == "*"
	result = a * b
end

if znak == "/"
	result = a / b
end

print"Результат #{result}"