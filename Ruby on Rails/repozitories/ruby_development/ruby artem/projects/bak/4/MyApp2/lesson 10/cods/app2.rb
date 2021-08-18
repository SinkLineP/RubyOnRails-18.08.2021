puts "Student our or school: "
	arr = ["walt","hank","jr","jessie","lidia"]

		x = 0
			arr.each do |name|
			puts "#{x} #{name}"
			x = x + 1
		end
while true 
	puts "Enter index number student: "
	
	n = gets.to_i
	arr.delete_at n - 1
	puts arr
end