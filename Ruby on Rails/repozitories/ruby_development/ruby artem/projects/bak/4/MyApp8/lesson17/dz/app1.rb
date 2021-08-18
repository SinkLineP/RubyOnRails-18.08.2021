input = File.open("/home/sinkline/Загрузки/hello.txt", "r")

while (line = input.gets)
	puts line
end

input.close