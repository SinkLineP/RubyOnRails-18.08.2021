class AddNmoMinistryHealthSpeciality < ActiveRecord::Migration
  def up
    courses_shop = Shop.find_by(code: :cosmetic)
    root_speciality = Speciality.root.find_by(title: 'Косметология',
                                              shop_id: courses_shop.id)
    Speciality.create!(title: 'НМО Минздрава', parent_id: root_speciality.id, shop_id: courses_shop.id)
  end

  def down
    courses_shop = Shop.find_by(code: :cosmetic)
    root_speciality = Speciality.root.find_by(title: 'Косметология',
                                              shop_id: courses_shop.id)
    speciality = Speciality.find_by(title: 'НМО Минздрава', parent_id: root_speciality.id, shop_id: courses_shop.id)
    speciality.destroy if speciality
  end
end
