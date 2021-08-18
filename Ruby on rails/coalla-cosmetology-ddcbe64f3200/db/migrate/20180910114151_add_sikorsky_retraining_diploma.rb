class AddSikorskyRetrainingDiploma < ActiveRecord::Migration
  def up
    EducationDocument.create!(title: 'Диплом о профессиональной переподготовке Школы Сикорской', code: 'sikorsky_retraining_diploma')
  end

  def down
    EducationDocument.where(code: 'sikorsky_retraining_diploma').destroy_all
  end
end
