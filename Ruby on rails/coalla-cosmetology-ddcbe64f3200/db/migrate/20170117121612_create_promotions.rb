class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.text :title
      t.text :announce
      t.text :image
      t.text :link
      t.boolean :visible
      t.timestamps
    end
  end
end
