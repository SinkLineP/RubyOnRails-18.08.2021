class AddLevelColumnToSpecialities < ActiveRecord::Migration
  def change
    add_column :specialities, :level, :integer, null: false, default: 0
    Speciality.create(title: 'Обучение парикмахеров с нуля', parent_id: 21,
                      shop_id: 2, show_on_site: true,
                      page_title: 'Обучение парикмахеров с нуля',
                      for_main: true, level: 2)
    Speciality.update(21, level: 1)
    Speciality.update(22, level: 3)
    Speciality.update(23, level: 4)
  end
end
