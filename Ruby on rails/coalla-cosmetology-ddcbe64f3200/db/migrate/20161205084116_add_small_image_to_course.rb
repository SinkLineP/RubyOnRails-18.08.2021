class AddSmallImageToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :small_image, :text
  end
end
