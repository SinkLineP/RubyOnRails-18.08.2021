module EducationDocuments
  class ProfessionalRetrainingCertificate < RetrainingCertificate

    def second_appendix
      ProfessionalRetrainingSecondAppendix.new(@item).generate
    end

    protected

    def certificate_filename
      'retraining_certificate'
    end

  end
end