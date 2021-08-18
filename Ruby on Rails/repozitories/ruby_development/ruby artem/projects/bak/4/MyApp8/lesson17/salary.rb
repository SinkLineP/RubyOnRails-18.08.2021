input = File.open("task.txt", "r")

total = 0

while line = input.gets
  total += line.split(",")[1].to_i
end

input.close

puts ""
puts "Total: ߷#{total}"
