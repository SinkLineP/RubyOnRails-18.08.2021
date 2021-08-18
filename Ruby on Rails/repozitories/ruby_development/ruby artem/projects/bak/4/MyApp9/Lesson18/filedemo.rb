def my_pass
	password = gets
end

def passwords
		while (line = my_pass.gets)
		line.strip
			if line.size == 6
				puts line
			end
		end
end

if my_pass == passwords || my_pass > passwords
	puts "hello"
else
	puts "buy"
end