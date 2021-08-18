
#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def get_db
	return SQLite3::Database.new 'base.sqlite'
end


configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "users" (
	"Id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"Username"	TEXT,
	"Phone"	TEXT,
	"Datastamp"	TEXT,
	"Barber"	TEXT,
	"Color"	TEXT
)'
db.close
end	


get '/' do
	erb "Hello!!!!!! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	
	erb :about
end	


get '/contacts' do
	erb :contacts
end	

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@data_time = params[:data_time]
	@barber = params[:barber]
	@color = params[:color]


  hh = {  :username => 'Введите имя',
  		  :phone => 'Введите телефон',
  		  :data_time => 'Введите дату и время' }

		@error = hh.select {|key,_| params[key] == ""}.values.join(",")

		if @error != ""
			return erb :visit
		end	


db = get_db
db.execute 'insert into 
users 
(username, phone, datastamp, barber, color)
 values ( ?, ?, ?, ?, ?)', [@username, @phone, @data_time, @barber, @color]
	
erb "Пользователь: #{@username} Время записи: #{@data_time} Связь с клиентом #{@phone}  Парикмахер: #{@barber} Выбран цвет: #{@colors} "
end	

get '/showusers' do
 erb "Hello World"
end

