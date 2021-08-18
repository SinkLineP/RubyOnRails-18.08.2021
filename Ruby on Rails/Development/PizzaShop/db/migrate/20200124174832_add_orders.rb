class AddOrders < ActiveRecord::Migration[5.2]
  def change
	create_table :addorders do |t|

		t.string :title 
		t.text :orders_input
		t.decimal :price 
		t.decimal :size 
		t.boolean :is_spicy 
		t.boolean :is_veg 
		t.boolean :is_best_offer 
		t.string :path_to_photo 

	t.timestamps
		end
  end
end
