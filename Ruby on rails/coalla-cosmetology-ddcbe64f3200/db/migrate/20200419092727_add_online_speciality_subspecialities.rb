class AddOnlineSpecialitySubspecialities < ActiveRecord::Migration
  TITLES = ['Вебинары', 'Записи вебинаров']

  def up
    courses_shop = Shop.find_by(code: :cosmetic)
    root_speciality = Speciality.find_by(title: 'Онлайн курсы', shop_id: courses_shop.id, parent_id: nil)
    return if courses_shop.blank? || root_speciality.blank?

    TITLES.each do |title|
      Speciality.create!(title: title, parent_id: root_speciality.id, shop_id: courses_shop.id)
    end
  end

  def down
    courses_shop = Shop.find_by(code: :cosmetic)
    root_speciality = Speciality.find_by(title: 'Онлайн курсы', shop_id: courses_shop.id, parent_id: nil)
    return if courses_shop.blank? || root_speciality.blank?

    Speciality.where(parent_id: root_speciality.id, shop_id: courses_shop.id, title: TITLES).destroy_all
  end
end
