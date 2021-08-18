hh = {'cat' => ['кошка', ' кот'], 'dog' => 'собака', 'girl' => 'девушка', 'boy' => 'мальчик'}

loop do 
	print "Enter word: "
	word = gets.chomp!

	translation = hh[word]
	puts "Translate: #{translation}"
end