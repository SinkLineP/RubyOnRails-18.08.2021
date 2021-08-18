class AddGenitiveFormToOnlineSpeciality < ActiveRecord::Migration
  def up
    Speciality.root.find_by(title: 'Онлайн курсы').update(genitive_form: 'Онлайн курсы')
  end

  def down
  end
end
