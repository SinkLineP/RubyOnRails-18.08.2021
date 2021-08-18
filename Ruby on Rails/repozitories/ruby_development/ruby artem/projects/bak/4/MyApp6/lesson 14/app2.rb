
class Book
	def initialize
	@hash = {}

		def add_person
			print "Enter name: "
			a = gets.chomp!
			print "Enter age: "
			b = gets.to_i

			@hash = { a => b }
		end

=begin
		def last_person

		end
=end
		def show boook
			puts @hash
			
		end
	end
end

bookk = Book.new
bookk.add_person

bookk = Book.new
bookk.show

