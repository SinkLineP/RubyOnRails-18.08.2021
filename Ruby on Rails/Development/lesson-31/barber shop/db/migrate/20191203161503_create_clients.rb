class CreateClients < ActiveRecord::Migration[5.2]
  def change
  	
  	create_table :clients do |t|
      t.string :username
      t.string :phone
      t.string :datetime
      t.string :barber
      t.string :color

  		t.timestamps
  	end
  end
end
