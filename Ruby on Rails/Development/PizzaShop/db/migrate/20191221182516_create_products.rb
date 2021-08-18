class CreateProducts < ActiveRecord::Migration[5.2]
	
  def change
  	create_table :products do |t|
    
    	t.string :title #наименование
    	t.text :description #описание
    	t.decimal :price #стоимость
    	t.decimal :size #размеры
    	t.boolean	:is_spicy #мясная: "true" or "false"
    	t.boolean	:is_veg #вегетарианская: "true" or "false"
    	t.boolean :is_best_offer #лучшее предложение
    	t.string :path_to_photo #путь к фото

  		t.timestamps
  	end

  	

  end
end
