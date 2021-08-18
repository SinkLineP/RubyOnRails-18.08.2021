@m = 1
@k = 2
@o = 3
@z = 4
@l = 5
@y = 6
@t = 7
@g = 8
@v = 9
       def bord
              puts "

                            |              |
                            |              |
                     #{@m}      |     #{@k}        |      #{@o}       
                            |              |
                            |              |
                            |              |
              ---------------------------------------------
                            |              |
                            |              |
                     #{@z}      |     #{@l}        |      #{@y}
                            |              |
                            |              |
                            |              |              
              ---------------------------------------------
                            |              |
                            |              |
                     #{@t}      |     #{@g}        |      #{@v} 
                            |              |
                            |              |
                            |              |

              "
       end
puts bord
# хешы
       hash2 = {}
       hash ={}
# массивы
       arr = [{"x" => 1}, {"x" => 2}, {"x" =>3 }, {"x" => 4}, {"x" => 5}, {"x" => 6}, {"x" => 7 }, {"x" => 8}, {"x" => 9}]
       arr2 = [{"o" => 1}, {"o" => 2}, {"o" =>3 }, {"o" => 4}, {"o" => 5}, {"o" => 6}, {"o" => 7 }, {"o" => 8}, {"o" => 9}]


while true

#print "ваш ход по X (или stop): " # X по горизонтали
a = "x"


print "Введите номер клетки или 0 для выхода: " # Y по вертикали

b = gets.to_i

if b == 0 # это условие чтобы выйти из программы
	break
end


hash[a] = b # это к ключу присваивается значение



#---------------------------------игрок
       if hash == arr[0]
       	@m = "X"
       elsif hash == arr[1]
       	@k = "X"
       elsif hash ==  arr[2]
       	@o = "X"
       elsif hash ==  arr[3]
       	@z = "X"
       elsif hash ==  arr[4]
       	@l = "X"
       elsif hash ==  arr[5]
       	@y = "X"
       elsif hash ==  arr[6]
       	@t = "X"
       elsif hash ==  arr[7]
       	@g = "X"
       elsif hash ==  arr[8]
       	@v = "X"
       end
#-----------------------------------компьютер

       
       c = "o"
       c1 = rand(1..9)
       hash2[c] = c1



       if hash2 == arr2[0]
       	@m = "O"
       elsif hash2 == arr2[1]
       	@k = "O"
       elsif hash2 ==  arr2[2]
       	@o = "O"
       elsif hash2 ==  arr2[3]
       	@z = "O"
       elsif hash2 ==  arr2[4]
       	@l = "O"
       elsif hash2 ==  arr2[5]
       	@y = "O"
       elsif hash2 ==  arr2[6]
       	@t = "O"
       elsif hash2 ==  arr2[7]
       	@g = "O"
       elsif hash2 ==  arr2[8]
       	@v = "O"
       end


if [@m,@k,@o] == "X"
       puts"winner"
       
end


puts bord
end