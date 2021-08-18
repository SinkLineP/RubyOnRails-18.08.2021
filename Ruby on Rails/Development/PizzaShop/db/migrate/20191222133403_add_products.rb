class AddProducts < ActiveRecord::Migration[5.2]
  def change
  	 Products.create ({
  	 	:title => 'Havaii', 
  	 	:description => 'This is Havaii pizza.', 
  	 	:price => 200, 
  	 	:size => 30, 
  	 	:is_spicy => false, 
  	 	:is_veg => false, 
  	 	:is_best_offer => false, 
  	 	:path_to_photo => '/images/havaii.jpg'})

  	Products.create ({
  		:title => 'Pepperoni',
  		:description => 'Nice Peperoni pizza.',
  		:price => 250,
  		:size => 40,
  		:is_spicy => false,
  		:is_veg => false,
  		:is_best_offer => false,
  		:path_to_photo => '/images/peperoni.jpg'})
  	
  	Products.create ({ 
  		:title => 'Vegetarian',
  		:description => 'like Veg pizza.',
  		:price => 150,
  		:size => 25,
  		:is_spicy => false,
  		:is_veg => false,
  		:is_best_offer => false,
  		:path_to_photo => '/images/veg.png'})

  	Products.create ({
  	 	:title => 'Havaii', 
  	 	:description => 'This is Havaii pizza.', 
  	 	:price => 200, 
  	 	:size => 30, 
  	 	:is_spicy => false, 
  	 	:is_veg => false, 
  	 	:is_best_offer => false, 
  	 	:path_to_photo => '/images/havaii.jpg'})

  	Products.create ({
  		:title => 'Pepperoni',
  		:description => 'Nice Peperoni pizza.',
  		:price => 250,
  		:size => 40,
  		:is_spicy => false,
  		:is_veg => false,
  		:is_best_offer => false,
  		:path_to_photo => '/images/peperoni.jpg'})
  	
  	Products.create ({ 
  		:title => 'Vegetarian',
  		:description => 'like Veg pizza.',
  		:price => 150,
  		:size => 25,
  		:is_spicy => false,
  		:is_veg => false,
  		:is_best_offer => false,
  		:path_to_photo => '/images/veg.png'})		  	
  end
end