class AddShopToModels < ActiveRecord::Migration
  def change
    SharedModels::CLASSES.each do |_class|
      add_reference _class.table_name, :shop, foreign_key: true, index: true
    end
  end
end
