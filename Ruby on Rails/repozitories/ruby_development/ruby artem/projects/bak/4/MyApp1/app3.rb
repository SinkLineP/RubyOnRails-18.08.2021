#encoding: cp866

puts "Сколько гостей будет?"

x=gets.to_i

if x < 1
	puts"ошибка"
	  exit

end

x.times do |x| 
puts"Отлично будет #{x+1} гостей"
end








=begin
if n != 0
	puts"Отлично кто-то будет!"
end
=end