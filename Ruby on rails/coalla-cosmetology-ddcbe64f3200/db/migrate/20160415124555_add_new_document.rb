class AddNewDocument < ActiveRecord::Migration
  def up
    EducationDocument.create! title: 'Удостоверение о повышении квалификации установленного Институтом образца в объеме 72 часа'
  end

  def down
  end
end
