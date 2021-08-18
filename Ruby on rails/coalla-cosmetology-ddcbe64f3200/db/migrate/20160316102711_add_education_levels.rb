class AddEducationLevels < ActiveRecord::Migration
  def up
    ['Высшее мед. образование + дерматология',
    'Высшее мед. образование',
    'Среднее мед. образование  (сестринское дело, фельдшер (лечебное дело), акушер, фельдшер-акушер)',
    'Иное среднее мед. образование',
    'Высшее образование',
    'Среднее образование',
    'Неоконченное высшее/среднее'].each { |level_title| EducationLevel.find_or_create_by!(title: level_title) }
  end

  def down
  end
end
