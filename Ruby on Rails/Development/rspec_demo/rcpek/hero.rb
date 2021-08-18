class Hero
	def initialize(name, health=100)
		@name = name.capitalize
		@health = health
	end

	def name 
		name = @name
	end

	def health_up
		@health += 10
	end

	def health_down
		@health -=10
	end

	def hero_info
		"The #{@name} has a health of #{@health}"
	end
end


# hero = Hero.new 'mike'
# puts hero.name
# puts hero.health_up
# puts hero.health_down
# puts hero.hero_info