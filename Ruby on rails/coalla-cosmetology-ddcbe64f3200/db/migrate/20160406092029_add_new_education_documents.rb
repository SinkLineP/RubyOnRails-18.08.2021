class AddNewEducationDocuments < ActiveRecord::Migration
  def change
    EducationDocument.create!(title: 'Диплом о дополнительном образовании')
    EducationDocument.create!(title: 'Сертификат специалиста "Медицинский массаж"')
  end
end
