class CreateSquareBanners < ActiveRecord::Migration
  def change
    create_table :square_banners do |t|
      t.boolean :active, null: false, default: false
      t.text :desktop_text, null: false
      t.text :mobile_text, null: false
      t.text :image
      t.text :mobile_image
      t.text :btn_title
      t.text :link
      t.references :shop, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
