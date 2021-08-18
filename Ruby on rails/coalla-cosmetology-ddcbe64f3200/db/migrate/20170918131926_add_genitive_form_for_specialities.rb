class AddGenitiveFormForSpecialities < ActiveRecord::Migration
  def change
    add_column :specialities, :genitive_form, :text
    Speciality.root.find_by(title: 'Косметология').update(genitive_form: 'Курсы косметологии')
    Speciality.root.find_by(title: 'Массаж').update(genitive_form: 'Курсы массажа')
    Speciality.root.find_by(title: 'Макияж и бровистика').update(genitive_form: 'Курсы макияжа и бровистики')
    Speciality.root.find_by(title: 'Менеджмент').update(genitive_form: 'Курсы менеджмента')
  end
end
