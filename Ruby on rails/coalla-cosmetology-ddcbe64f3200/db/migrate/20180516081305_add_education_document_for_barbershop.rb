class AddEducationDocumentForBarbershop < ActiveRecord::Migration
  def up
    EducationDocument.create!(title: 'Сертификат Школы парикмахерского мастерства Светланы Сикорской',
                              code: 'barbershop_certificate',
                              builder: 'BarbershopCertificate')
    EducationDocument.create!(title: 'Диплом Школы парикмахерского мастерства Светланы Сикорской',
                              code: 'barbershop_diploma',
                              builder: 'BarbershopDiploma')
  end

  def down
    EducationDocument.where(code: %w(barbershop_diploma barbershop_certificate)).destroy_all
  end
end
