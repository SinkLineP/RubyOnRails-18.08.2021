require 'sqlite3'

db = SQLite3::Database.new 'BarberShop.db'
db.execute "INSERT INTO Users (Name, Phone, DateStamp, Barber, Color) VALUES ('Karina', 380956151232, '11.10.2019', 'Misha', 'Yellow')"
db.execute "INSERT INTO Contacts (Email, Message) VALUES ('Karina@gmail.com', 'You work ok!')"
db.close
