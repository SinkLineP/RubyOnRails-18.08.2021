class AddOnlineSpeciality < ActiveRecord::Migration
  def up
    add_column :specialities, :for_main, :boolean, null: false, default: true
    courses_shop = Shop.find_by(code: :cosmetic)
    root_speciality = Speciality.create!(title: 'Онлайн курсы',
                                         shop_id: courses_shop.id,
                                         icon: 'online-education')
    Speciality.create!(title: 'Онлайн курсы', parent_id: root_speciality.id, shop_id: courses_shop.id)
    Speciality.where(shop_id: courses_shop.id, title: 'Менеджмент', parent_id: nil).update_all(for_main: false)
  end

  def down
    courses_shop = Shop.find_by(code: :cosmetic)
    speciality = Speciality.find_by(title: 'Онлайн курсы',
                                    shop_id: courses_shop.id,
                                    icon: 'online-education',
                                    parent_id: nil)
    if speciality
      Speciality.where(parent_id: speciality.id).destroy_all
      speciality.destroy
    end
    remove_column :specialities, :for_main
  end
end
