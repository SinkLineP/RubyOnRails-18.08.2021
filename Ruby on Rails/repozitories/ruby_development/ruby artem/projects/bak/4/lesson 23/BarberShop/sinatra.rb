require 'rubygems'
require 'sinatra'
#require 'sinatra/reloader'

@hash = []
#-------------------------------------------------------------------------------------------
get '/' do 
	erb :index
end



get '/login' do
	erb :login
end

get '/about' do
	erb :about
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

get '/visit' do 
	erb :visit
end

post '/visit' do 
		
		@username = params[:username]
		@phone = params[:phone]
		@datetime = params[:datetime]
		@barber = params[:barber]
		@color = params[:color]

	if @username == "" && @phone == "" && @datetime == "" && @barber == "-=Не выбрано=-" || @username == "" || @barber == "-=Не выбрано=-" || @phone == "" || @datetime == "" || @username == "" && @phone == "" || @username == "" && @datetime == "" || @username == "" && @barber == "-=Не выбрано=-" || @phone == "" && @datetime == "" || @phone == "" && @barber == "-=Не выбрано=-" || @datetime == "" && @barber == "-=Не выбрано=-"

		@title = "Вы не заполнили формы"
		erb :error
	else

		@title = "Thank you!"
		@message = "Hello, #{@username} your application has been sent to '#{@datetime}', Barber: #{@barber}."

		f = File.open 'user.txt', 'a'
		f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@datetime}, Barber: #{@barber}\n"
		f.close

		erb :message
	end

	erb :visit

end


post '/visit' do #огда браузер хочет отправить какие-то данные
	
end


