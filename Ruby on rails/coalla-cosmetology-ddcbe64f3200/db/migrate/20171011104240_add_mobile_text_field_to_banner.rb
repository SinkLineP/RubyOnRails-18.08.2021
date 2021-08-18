class AddMobileTextFieldToBanner < ActiveRecord::Migration
  def change
    add_column :banners, :mobile_text, :text
    add_column :banners, :mobile_image, :text
  end
end
