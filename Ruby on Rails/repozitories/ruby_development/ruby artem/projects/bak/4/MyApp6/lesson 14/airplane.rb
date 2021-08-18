class Airplane
	attr_reader :model     #модель
	attr_reader :altitude  #высота
	attr_reader :speed	   #скорость

		def initialize(model)
			@model = model
			@speed = 0
			@altitude = 0
		end


		def fly
			@speed = 800
			@altitude = 1000
		end

		def land
			@speed = 0
			@altitude = 0
		end

		def moving?
			return @speed > 0 
		end

end
	

plane1 = Airplane.new('Mriya')
puts "============================================================"
puts "------------------------------------------------------------"
puts "Model: #{plane1.model}, Speed: #{plane1.speed}, Altitude: #{plane1.altitude}"
puts "Is moving: #{plane1.moving?}"
sleep 0.2

plane1.fly
puts "------------------------------------------------------------"
puts "Model: #{plane1.model}, Speed: #{plane1.speed}, Altitude: #{plane1.altitude}"
puts "Is moving: #{plane1.moving?}"
sleep 0.2

plane1.land
puts "------------------------------------------------------------"
puts "Model: #{plane1.model}, Speed: #{plane1.speed}, Altitude: #{plane1.altitude}"
puts "Is moving: #{plane1.moving?}"
sleep 0.2
puts "------------------------------------------------------------"
puts "============================================================"

plane2 = Airplane.new('Boinge-777')
puts "------------------------------------------------------------"
puts "Model: #{plane2.model}, Speed: #{plane2.speed}, Altitude: #{plane2.altitude}"
puts "Is moving: #{plane2.moving?}"
sleep 0.2

plane2.fly
puts "------------------------------------------------------------"
puts "Model: #{plane2.model}, Speed: #{plane2.speed}, Altitude: #{plane2.altitude}"
puts "Is moving: #{plane2.moving?}"
sleep 0.2

plane2.land
puts "------------------------------------------------------------"
puts "Model: #{plane2.model}, Speed: #{plane2.speed}, Altitude: #{plane2.altitude}"
puts "Is moving: #{plane2.moving?}"
sleep 0.2
puts "------------------------------------------------------------"
puts "============================================================"

plane3 = Airplane.new('Hydra')
puts "------------------------------------------------------------"
puts "Model: #{plane3.model}, Speed: #{plane3.speed}, Altitude: #{plane3.altitude}"
puts "Is moving: #{plane3.moving?}"
sleep 0.2

plane3.fly
puts "------------------------------------------------------------"
puts "Model: #{plane3.model}, Speed: #{plane3.speed}, Altitude: #{plane3.altitude}"
puts "Is moving: #{plane3.moving?}"
sleep 0.2

plane3.land
puts "------------------------------------------------------------"
puts "Model: #{plane3.model}, Speed: #{plane3.speed}, Altitude: #{plane3.altitude}"
puts "Is moving: #{plane3.moving?}"
sleep 0.2
puts "------------------------------------------------------------"
puts "============================================================"
