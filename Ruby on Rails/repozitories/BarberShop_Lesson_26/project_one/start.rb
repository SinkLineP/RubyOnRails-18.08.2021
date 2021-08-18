require 'sqlite3'

db = SQLite3::Database.new 'data.db'

db.execute 'select * from Users' do |row|
	puts row
	puts "============================"
end