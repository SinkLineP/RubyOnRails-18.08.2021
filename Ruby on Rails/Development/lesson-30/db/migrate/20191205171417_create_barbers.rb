class CreateBarbers < ActiveRecord::Migration[5.2] # тут должно быть в ковычках [5.2]

	def change    

  	create_table :barbers do |t|
  		t.string :name

  		t.timestamps
  	end

		Barbers.create :name => 'Jessie Pickman' # создает в базе данных
	 	Barbers.create :name => 'Walter White'
	 	Barbers.create :name => 'Gus Fring'


  end
end
