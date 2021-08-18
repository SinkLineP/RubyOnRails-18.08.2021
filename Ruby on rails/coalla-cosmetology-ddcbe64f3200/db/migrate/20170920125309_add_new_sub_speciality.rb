class AddNewSubSpeciality < ActiveRecord::Migration
  def up
    root_speciality = Speciality.root.find_by(title: 'Макияж и бровистика')
    root_speciality.children.create!(title: 'Грим')
    root_speciality.children.find_by(title: 'Макияж').update(title: 'Перманентный макияж')
  end

  def down
    root_speciality = Speciality.root.find_by(title: 'Макияж и бровистика')
    root_speciality.children.find_by(title: 'Грим').destroy
    root_speciality.children.find_by(title: 'Перманентный макияж').update(title: 'Макияж')
  end
end
