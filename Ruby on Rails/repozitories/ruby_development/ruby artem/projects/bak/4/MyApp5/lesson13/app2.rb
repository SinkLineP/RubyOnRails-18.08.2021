class book 
	def add_person
		print "Enter name: "
		a = gets.chomp!
		print "Enter age: "
		b = gets.to_i

		hash[a] = b
	end

	def show boook
		x = 0
		boook.each do |name, age|
			x = x +1
			puts "#{x} #{name} - #{age}."
		end
	end
end

bookk = book.new
bookk.add_person
bookk.show

