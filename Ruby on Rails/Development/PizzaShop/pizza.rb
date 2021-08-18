hh = {}

loop do
	print "Enter product id: "
	id = gets.chomp

	print "Enter col-vo product: "
	n = gets.chomp.to_i

	x = hh[id].to_i
	x = x + n
	hh[id] = x

	puts hh.inspect
	puts "========================="
end