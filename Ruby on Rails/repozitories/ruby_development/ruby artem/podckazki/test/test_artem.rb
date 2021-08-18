hash = {}

print "pridumayte password: "
n = gets.chomp

print "Enter your password: "
b = gets.chomp

l = rand (000000..999999)

if b == n
    
      while true
          print "print product: "

          a = gets.chomp!

        if a == "stop"
          break
        end
          print "print her col_vo: "
          b = gets.chomp!
          hash == { a => b}
      end
end

x = 0
puts "your zakaz ophormlen № #{l}"
puts"=============================="
hash.uniq do |item|
  x = x + 1
  puts "#{x}. #{item[0]} #{item[1]}"
end
puts"=============================="