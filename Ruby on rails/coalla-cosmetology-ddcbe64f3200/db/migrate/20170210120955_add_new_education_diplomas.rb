class AddNewEducationDiplomas < ActiveRecord::Migration
  def up
    EducationDocument.create!(title: 'Диплом MBA', code: 'mba_diploma')
    EducationDocument.create!(title: 'Диплом о проф переподготовке ВШЭ', code: 'retraining_hse_diploma')
  end

  def down
    EducationDocument.where(code: %w(mba_diploma retraining_hse_diploma)).destroy_all
  end
end
