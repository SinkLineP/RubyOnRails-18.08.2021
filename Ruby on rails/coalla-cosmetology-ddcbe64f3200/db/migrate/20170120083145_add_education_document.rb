class AddEducationDocument < ActiveRecord::Migration
  def up
    EducationDocument.create!(title: 'Сертификат специалиста государственного образца по дерматовенерологии', code: 'dermatology_certificate')
  end

  def down
    EducationDocument.find_by(code: 'dermatology_certificate').destroy
  end
end
