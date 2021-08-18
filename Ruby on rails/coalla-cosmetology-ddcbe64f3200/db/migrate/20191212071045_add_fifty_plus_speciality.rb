class AddFiftyPlusSpeciality < ActiveRecord::Migration
  def change
    special = Speciality.new(title: 'Бесплатные курсы 50+',
                            shop_id: 1, show_on_site: true,
                            page_title: 'Бесплатные курсы 50+',
                            for_main: true, level: 50, icon: 'fifty-plus')
    if special.save
      Speciality.create(title: 'Бесплатные курсы 50+',
                            shop_id: 1, show_on_site: true,
                            page_title: 'Бесплатные курсы 50+',
                            for_main: true, level: 50, parent_id: special.id)
    end
    Speciality.update(1, level: 10)
    Speciality.update(7, level: 20)
    Speciality.update(12, level: 30)
    Speciality.update(15, level: 40)
    Speciality.update(30, level: 60, for_main: false)
  end
end
