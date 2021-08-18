require 'net/http'

net = Net::HTTP.get('http://localhost:4567/')
puts net