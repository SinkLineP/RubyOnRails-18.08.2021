#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index
end

# спросим Имя, номер телефона и дату, когда придёт клиент.
post '/' do
  # user_name, phone, date_time
  @user_name = params[:user_name]
  @phone = params[:phone]
  @date_time = params[:date_time]

  @title = "Thank you!"
  @message = "Уважаемый #{@user_name}, мы ждём вас в #{@date_time}"

  # запишем в файл то, что ввёл клиент
  f = File.open 'users.txt', 'a'
  f.write "User: #{@user_name}, phone: #{@phone}, date and time: #{@date_time}.\n"
  f.close

  erb :message
end

get '/admin' do
  erb :admin
end

post '/admin' do
  @login = params[:login]
  @password = params[:password]

  # проверим логин и пароль, и пускаем внутрь или нет:
  if @login == 'admin' && @password == 'karamalesa'
    @file = File.open("./users.txt","r")
    erb :watch_result
    # @file.close - должно быть, но тогда не работает. указал в erb
  else
    @report = '<p>Доступ запрещён! Неправильный логин или пароль.</p>'
    erb :admin
  end
end

get '/contacts' do
  @title = "Contacts"
  @message = "Hello all! Phone me now."
  erb :message
end

get '/faq' do
  @title = "FAQ about our products"
  @message = "It`s FAQ"
  erb :message
end

get '/none-page' do
  under_construction
end

def under_construction
  @title = "Under Construction"
  @message = "This page is under construction."
  erb :message
end