#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

def get_db
   @db =  SQLite3::Database.new 'data.db'
   @db.results_as_hash = true
  return @db
end

before do
	@db = get_db
	@barbers = @db.execute 'select * from Barbers'
end

configure do 
	@db = get_db
	@db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'
	@db.execute 'CREATE TABLE IF NOT EXISTS
		"Barbers"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT
		)'
	seed_db @db, ['Misha', 'Karina', 'Vova', 'Himan']
end

get '/' do
	erb "Hello! my github: <a href=\"https://github.com/SinkLineP/\">SinkLine_P</a>, and my channel: <a href=\"https://www.youtube.com/channel/UCV3V0MWW0d5xx6T4pxjZauQ?view_as=subscriber/\">My YouTube</a>."
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do 
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hash = { :username => 'Введите имя',
			 :phone => 'Введите телефон',
			 :datetime => 'Введите дату и время'}

	@error = hash.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ""
		return erb :visit
	end

	@db = get_db
	@db.execute 'insert into 
		Users
		(
			username, 
			phone, 
			datestamp, 
			barber, 
			color
		)
		values ( ?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]


	@title = "Thank you!"
	@message = "<h2>Вы записаны!</h2>"

	f = File.open 'public/users.txt', 'a'
	f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@datetime}, Barber: #{@barber}, Color: #{@color}.\n"
	f.close

	erb :message
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do

	@email = params[:email]
	@message = params[:message]

	hash = { :email => 'Введите ваш EMAIL',
			 :message => 'Введите ваш ОТЗЫВ'}

	@error = hash.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ""
		return erb :contacts
	end

		@title = "Thank you!"
		@message = "Привет мы вам в скором времени ответим, #{@email}."

		f = File.open 'public/contacts.txt', 'a'
		f.write "User: #{@email}, Message: #{@message}.\n"
		f.close

	erb :message
end


get '/showusers' do
	@db = get_db
    
    @results = @db.execute 'SELECT * FROM Users ORDER BY id DESC'
    @db.close
	erb :showusers
end