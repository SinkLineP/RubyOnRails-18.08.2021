module CoursesShop
  module DocumentsHelper

    def document_type_text(document)
      if document.is_a?(DocumentCopy)
        'Копия документа об образовании'
      elsif document.is_a?(StudentDocument)
        t("enumerize.student_document.document_type.#{document.document_type}")
      else
        ''
      end
    end

    def load_document_types
      StudentDocument.document_type.options << ['Копия документа об образовании', 'document_copy']
    end

  end
end