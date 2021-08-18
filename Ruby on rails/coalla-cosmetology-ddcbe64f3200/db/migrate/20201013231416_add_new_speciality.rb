class AddNewSpeciality < ActiveRecord::Migration
  def up
    Speciality.create(
      title: 'Онлайн курсы с практикой',
      parent_id: 30,
      slug: 'online-kursi-s-praktikoi',
      page_title: 'Онлайн курсы с практикой',
      shop_id: 1,
      level: 20
      )
    Speciality.update(31, level: 10)
    Speciality.update(38, level: 30)
    Speciality.update(39, level: 40)
  end

  def down
    Speciality.find_by(slug: 'online-kursi-s-praktikoi').try(:destroy)
  end
end
