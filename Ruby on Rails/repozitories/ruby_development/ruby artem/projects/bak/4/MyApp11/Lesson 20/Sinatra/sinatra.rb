require 'sinatra'

get '/' do #когда браузер хочет получить какие-то данные
	erb :index
end

post '/' do #огда браузер хочет отправить какие-то данные
	@login = params[:login]
	@password = params[:password]

	if @login == "admin" && @password == "karamalesa"
		erb :welcome
	else
		erb :error
	end
end


