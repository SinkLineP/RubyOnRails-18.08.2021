  print 'Введите расстояние в метрах: '
  d = gets.to_i

  print 'Введите время в секундах: '
  t = gets.to_i
while true
    if  t < 0
    	 print'Время не может быть нулем'
    	 print 'Введите время в секундах: '
  		t = gets.to_i
  	else
  		break
 	end
 end

  
  c = d / t

  print 'Скорость #{c}'

 
