class ChangeCertificateTypeToEducationDocument < ActiveRecord::Migration
  def up
    education_document = EducationDocument.find_by(code: 'professional_retraining_diploma')
    education_document.update(builder: 'ProfessionalRetrainingCertificate') if education_document
  end

  def down
    education_document = EducationDocument.find_by(code: 'professional_retraining_diploma')
    education_document.update(builder: 'RetrainingCertificate') if education_document
  end
end
