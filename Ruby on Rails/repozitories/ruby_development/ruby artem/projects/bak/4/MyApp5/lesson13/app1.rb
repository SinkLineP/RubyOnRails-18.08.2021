# выводит на экран записную книгу
def show_book book
  book.each do |name, age|
    puts "<b>hello #{name} is </b><u>#{age} years old</u><br>"
  end
end

book1 = { 'Mike' => 65, 'Joe' => 12 }
book2 = { "John" => 88, 'Alisha' => 44 }

show_book book1
show_book book2

# or you can merge 2 hashes
book = book1.merge book2
show_book book

#or you can merge 2 hashes with .merge!
book1.merge! book2
show_book book1