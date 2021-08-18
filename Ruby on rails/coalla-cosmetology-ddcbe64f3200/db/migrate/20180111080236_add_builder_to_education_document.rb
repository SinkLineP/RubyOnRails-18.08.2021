class AddBuilderToEducationDocument < ActiveRecord::Migration
  def up
    add_column :education_documents, :builder, :string

    {
      'retraining_diploma' => 'RetrainingCertificate',
      'massage_certificate' => 'SpecialistCertificate',
      'health_organization_certificate' => 'SpecialistCertificate',
      'cosmetology_certificate' => 'SpecialistCertificate',
      'nursing_certificate' => 'SpecialistCertificate',
      'additional_education_diploma' => 'AdditionalEducationDiploma',
      '72_hours_training_certificate' => 'HoursTrainingCertificate',
      'wall_diploma' => 'WallDiploma',
      'module_certificate' => 'ModuleCertificate',
      'training_certificate' => 'TrainingCertificate'
    }.each do |code, builder|
      EducationDocument.where(code: code).update_all(builder: builder)
    end
  end

  def down
    remove_column :education_documents, :builder
  end
end
