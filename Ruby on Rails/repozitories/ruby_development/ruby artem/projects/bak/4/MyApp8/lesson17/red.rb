input = File.open "hello.txt", "r"

while (line = input.gets)
	puts line
end

input.close