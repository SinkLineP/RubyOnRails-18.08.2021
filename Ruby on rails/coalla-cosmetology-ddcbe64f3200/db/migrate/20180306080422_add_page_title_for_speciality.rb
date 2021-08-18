class AddPageTitleForSpeciality < ActiveRecord::Migration
  def up
    add_column :specialities, :page_title, :text
    Speciality.find_each do |speciality|
      speciality.update_columns(page_title: speciality.title)
    end
  end

  def down
    remove_column :specialities, :page_title
  end
end
