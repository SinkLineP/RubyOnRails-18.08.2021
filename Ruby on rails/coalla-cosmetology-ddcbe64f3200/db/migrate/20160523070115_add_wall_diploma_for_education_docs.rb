class AddWallDiplomaForEducationDocs < ActiveRecord::Migration
  def up
    EducationDocument.create!(title: 'Настенный диплом', code: 'wall_diploma')
  end

  def down
    EducationDocument.find_by(code: 'wall_diploma').destroy
  end
end
