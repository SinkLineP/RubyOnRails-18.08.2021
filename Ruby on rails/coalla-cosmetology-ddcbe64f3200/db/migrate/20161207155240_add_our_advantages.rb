class AddOurAdvantages < ActiveRecord::Migration
  def up
    Lookup.create!(type_code: :memo, category: :our_advantages, code: :graduate, value: 'Работаем с 1989 года и выпустили 10 000 студентов')
    Lookup.create!(type_code: :memo, category: :our_advantages, code: :documentation, value: 'Выдаем документы государственного образца, соответствующие требованиям лицензирующих органов')
    Lookup.create!(type_code: :memo, category: :our_advantages, code: :diploma, value: 'Выдаем международный диплом позволяющий работать в 42 странах мира')
    Lookup.create!(type_code: :memo, category: :our_advantages, code: :employment, value: 'Трудоустройство выпускников, среди работодателей - Babor, Балчуг Kempinski, Линлайн, Dessange, Aldo Coppola, Моне, Единая Европа Холдинг')
    Lookup.create!(type_code: :memo, category: :our_advantages, code: :teachers, value: 'Опытные преподаватели-практики и врачи-косметологи')
    Lookup.create!(type_code: :memo, category: :our_advantages, code: :internet, value: 'Система дистанционного обучения позволяет изучить теорию через Интернет')
  end

  def down
    Lookup.where(category: :our_advantages).delete_all
  end
end
