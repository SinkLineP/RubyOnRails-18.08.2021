class AddBarbershopOnlineSpeciality < ActiveRecord::Migration
  def up
    courses_shop = Shop.find_by(code: :barbershop)
    root_speciality = Speciality.create!(title: 'Онлайн школа парикмахеров',
                                         shop_id: courses_shop.id,
                                         genitive_form: 'Онлайн школа парикмахеров',
                                         icon: 'online-education')
    Speciality.create!(title: 'Онлайн школа парикмахеров', parent_id: root_speciality.id, shop_id: courses_shop.id)
  end

  def down
    courses_shop = Shop.find_by(code: :barbershop)
    speciality = Speciality.find_by(title: 'Онлайн школа парикмахеров',
                                    shop_id: courses_shop.id,
                                    icon: 'online-education',
                                    parent_id: nil)
    if speciality
      Speciality.where(parent_id: speciality.id).destroy_all
      speciality.destroy
    end
  end
end
