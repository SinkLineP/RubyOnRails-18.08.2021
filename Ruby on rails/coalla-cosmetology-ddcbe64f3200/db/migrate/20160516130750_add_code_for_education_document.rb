class AddCodeForEducationDocument < ActiveRecord::Migration
  def up
    add_column :education_documents, :code, :text

    {'Диплом о профессиональной переподготовке установленного Институтом образца' => 'retraining_diploma',
    'Диплом Международного терапевтического совета ITEC Beauty Specialist Level 2' => 'itec_diploma',
    'Сертификат специалиста "Cестринское дело в косметологии"' => 'nursing_certificate',
    'Сертификат специалиста "Косметология"' => 'cosmetology_certificate',
    'Удостоверение о повышении квалификации установленного Институтом образца' => 'training_certificate',
    'Сертификат Института об освоении отдельных модулей программы' => 'module_certificate',
    'Сертификат специалиста "Организация здравоохранения"' => 'health_organization_certificate',
    'Диплом о дополнительном образовании' => 'additional_education_diploma',
    'Сертификат специалиста "Медицинский массаж"' => 'massage_certificate',
    'Удостоверение о повышении квалификации установленного Институтом образца в объеме 72 часа' => '72_hours_training_certificate'}.each do |key, value|
      document = EducationDocument.find_by(title: key)
      document.update(code: value) if  document
    end

    change_column_null :education_documents, :code, false
  end

  def down
    remove_column :education_documents, :code
  end
end
