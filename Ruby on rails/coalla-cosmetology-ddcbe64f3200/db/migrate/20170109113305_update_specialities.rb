class UpdateSpecialities < ActiveRecord::Migration
  def up
    root = Speciality.find_by(title: 'Маникюр и педикюр')
    return unless root
    root.update_columns(title: 'Макияж и бровистика')
    root.children.find_by(title: 'Обучение маникюру').try(:update_columns, title: 'Макияж', description: nil)
    root.children.find_by(title: 'Повышение квалификации').try(:update_columns, title: 'Бровистика', description: nil)
  end

  def down
  end
end
