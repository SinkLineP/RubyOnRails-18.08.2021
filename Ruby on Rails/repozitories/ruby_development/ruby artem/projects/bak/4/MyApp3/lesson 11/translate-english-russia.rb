hash = {'live' => ['жить', 'живой', 'прямо'], 'love' => ['любить'], 'lie' => ['лгать', 'врать'], 'i' => ['я'], "hello"=>["привет"]}


while true
	print "Enter word: "
	word = gets.chomp!

	translate = hash[word]
	
	#puts "the translate: #{translate}"

	x = 0
	puts "========================"
	translate.each do |trans|
	x = x + 1

	puts "#{trans}"

	end
	puts "========================="
	puts "total translations:  #{x}"
	puts ""

end

