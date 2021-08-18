class AddNewEducationDocument < ActiveRecord::Migration
  def up
    EducationDocument.create!(title: 'Диплом о проф. переподготовке',
                              code: 'professional_retraining_diploma',
                              builder: 'RetrainingCertificate')
  end

  def down
    EducationDocument.where(code: %w(professional_retraining_diploma)).destroy_all
  end
end
