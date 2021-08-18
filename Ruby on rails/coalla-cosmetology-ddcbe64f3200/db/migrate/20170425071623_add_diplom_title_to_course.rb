class AddDiplomTitleToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :diplom_title, :text
  end
end
