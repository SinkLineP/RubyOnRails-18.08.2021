class Country    
  attr_reader :countr
  def initialize(countr)
    @countr = countr
  end
end

class Airport
  attr_reader :name, :planes

  def initialize(name)
    @name = name
    @planes = []
  end

  def add_plane plane
    @planes << plane
  end
end

class Plane
  attr_reader :model

  def initialize(model)
    @model = model
  end
end


country = []

  airports = []

country1 = Country.new "borosvkoe"
country2 = Country.new "severodonetsk" 

  airport1 = Airport.new "bor"
  airport2 = Airport.new "sev"

country << country1
country << country2

  airports << airport1
  airports << airport2

    plane1 = Plane.new "Slayser"
    plane2 = Plane.new "Mriya"
    plane3 = Plane.new "Hydra"

  airport1.add_plane plane1
  airport1.add_plane plane2
  airport1.add_plane plane3

    plane2_1 = Plane.new "sever"
    plane2_2 = Plane.new "night"
    plane2_3 = Plane.new "flying"
    plane2_4 = Plane.new "planes"

  airport2.add_plane plane2_1
  airport2.add_plane plane2_2
  airport2.add_plane plane2_3
  airport2.add_plane plane2_4


  puts "========================="
country.each do |city|
  puts "Country: #{city.countr}"

  airports.each do |airport|
    puts "--Airport: #{airport.name}"

    puts "-Planes in this airport:"
    airport.planes.each do |plane|
      puts "----#{plane.model}"
      end
    end
  puts "========================="
end