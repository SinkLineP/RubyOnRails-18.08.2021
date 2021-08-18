class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.text :type_banner
      t.text :description, null: false
      t.text :image, null: false
      t.text :btn_title
      t.text :link_call
      t.boolean :active, null: false, default: false

      t.timestamps null: false
    end
  end
end


