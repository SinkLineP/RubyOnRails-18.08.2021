class CreateAboutImages < ActiveRecord::Migration
  def change
    create_table :about_images do |t|
      t.text :type
      t.text :name
      t.text :image
      t.timestamps
    end
  end
end
