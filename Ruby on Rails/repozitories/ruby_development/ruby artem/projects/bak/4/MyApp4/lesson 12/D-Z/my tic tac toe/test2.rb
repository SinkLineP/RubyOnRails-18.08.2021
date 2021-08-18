#arr = []
@a1 = " "
@a2 = " "
@a3 = " "
@b1 = " "
@b2 = " "
@b3 = " "
@c1 = " "
@c2 = " "
@c3 = " "

def massa
	[@a1, @a2, @a3, @b1, @b2, @b3, @c1, @c2, @c3]
end

def user
	hash_user = {"a1" => @a1, "a2" => @a2, "a3" => @a3, "b1" => @b1, "b2" => @b2, "b3" => @b3, "c1" => @c1, "c2" => @c2, "c3 => @c3"}
end

def board
	puts "
		  1 2 3
		A #{@a1}|#{@a2}|#{@a3}
		  =====
		B #{@b1}|#{@b2}|#{@b3}
		  =====
		C #{@c1}|#{@c2}|#{@c3}
	"
end
	puts board



	puts "Введите число: "
	a = gets.capitalize

	if hash_user == a
	end

























=begin
while true
	puts "вы играете за (X)"
	print "введите ячейку: "
	a = "x"
	b = gets.to_i

	n = hash[a] = b
	
		if hash == arr[0]
			@q = "X"
		elsif hash == arr[1]
			@w = "X"
		elsif hash == arr[2]
			@e = "X"
		elsif hash == arr[3]
			@r = "X"
		elsif hash == arr[4]
			@t = "X"
		elsif hash == arr[5]
			@y = "X"
		elsif hash == arr[6]
			@u = "X"
		elsif hash == arr[7]
			@i = "X"
		elsif hash == arr[8]
			@o = "X"	
		end
	puts board
end
=end