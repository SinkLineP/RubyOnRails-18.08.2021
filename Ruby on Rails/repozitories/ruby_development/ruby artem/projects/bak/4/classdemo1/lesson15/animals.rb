class Animal
	def initialize name
		@name = name
	end
	def run
		puts "#{name} run"
	end

	def jump
		puts "jump"
	end
end

class Cat < Animal
	def initalize
		puts "super dog"
	end
 puts "meoo"
end

cat = Cat.new
cat.run