require 'rubygems'
require 'sinatra'
#require 'sinatra/reloader'

get '/' do 
	erb :index
end

get '/login' do
	erb :login
end

post '/login' do
	login = params[:login]
	password = params[:password]

	if login == "admin" && password == "karamalesa"
		@logfile = File.open("user.txt","r")
    	erb :admin_panel

	else
		@error = "Не правельный логин или пароль"
		erb :login
	end

end


post '/' do 
		
		@username = params[:username]
		@phone = params[:phone]
		@datetime = params[:datetime]

	if @username == "" && @phone == "" && @datetime == "" || @username == "" || @phone == "" || @datetime == "" || @username == "" && @phone == "" || @username == "" && @datetime == "" || @phone == "" && @datetime == ""

		@title = "Вы не заполнили формы"
	else

		@title = "Thank you!"
		@message = "Hello, #{@username} your application has been sent to '#{@datetime}'."

		f = File.open 'user.txt', 'a'
		f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@datetime}.\n"
		f.close

		erb :message
	end
end


post '/' do #огда браузер хочет отправить какие-то данные
	
end


