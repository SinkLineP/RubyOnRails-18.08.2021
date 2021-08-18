require 'sinatra'
require 'sinatra/reloader'

require 'sinatra/activerecord'
require 'active_record'
require 'sqlite3'


set :database, {adapter: "sqlite3", database: "barber.db"}

class Clients < ActiveRecord::Base
  validates :username, presence: true, length: { minimum: 3 }
  validates :phone, presence: true
  validates :datetime, presence: true
  validates :barber, presence: true
  validates :color, presence: true
end

class Barbers < ActiveRecord::Base
end

class Contacts < ActiveRecord::Base
end

class Comments < ActiveRecord::Base
end



before do
	@barbers = Barbers.all
  @clients = Clients.all
end

get '/' do
	erb :index
end

get '/visit' do
	@c = Clients.new
	erb :visit
end

# post '/visit' do 

# 	c = Clients.new params[:client]
# 	c.save
#     if c.save
# 		erb "<h2>Спасибо вы записались!!</h2>"
# 	else
# 		erb "<h2>Ошибка</h2>"
# 	end
# end
#------------------------------------------------------

post '/visit' do
  @c = Clients.new params[:client]
  @c.save

  if @c.save
    erb "<p>Thank you!</p>"
  else
    @error = @c.errors.full_messages.first
    erb :visit
  end

end

get '/clients' do
  @clients = Clients.order('created_at DESC')

  erb :clients
end

get '/barber/:id' do 
	@barbers = Barbers.find(params[:id])
  @comments = Comments.where(barbers_id: @barbers.id).order(created_at: :desc)
	erb :barber
end

get '/bookings' do
	@clients = Clients.order('created_at DESC')
	erb :bookings
end 

get '/clients/:id' do 
	@client = Clients.find(params[:id])
	erb :client
end

post '/comment/:id' do
  num = Barbers.find(params[:id]) 
  @comments = Comments.new params[:comment]
  @comments.barbers_id = num.id
  @comments.save

  erb "Спасибо большое, за ваш отзыв."
end

