#encoding: UTF-8

arr=[]

while true

   print"enter yuor live color (or stop for ENTER ): "

   n = gets.strip	
	
   if n == "stop"
     puts"‚®в ў иЁ жўҐв ."
     puts arr.uniq!.reverse 
     exit
   end
   
   arr << n

end

