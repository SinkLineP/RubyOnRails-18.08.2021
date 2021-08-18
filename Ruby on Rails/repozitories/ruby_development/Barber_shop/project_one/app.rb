#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


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

	@title = "Thank you!"
	@message = "Hello, #{@username} your application has been sent to '#{@datetime}', Barber: #{@barber}, Color: #{@color}."

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


