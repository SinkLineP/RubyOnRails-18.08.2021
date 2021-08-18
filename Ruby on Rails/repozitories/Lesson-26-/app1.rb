require 'sqlite3'

db = SQLite3::Database.new 'movie.sqlite3'

db.execute "SELECT * FROM spn" do |spn|
	puts spn
	puts "======="
end	

db.close
