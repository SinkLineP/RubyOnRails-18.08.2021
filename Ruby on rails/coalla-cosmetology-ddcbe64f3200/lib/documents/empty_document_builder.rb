module Documents
  class EmptyDocumentBuilder < DocumentBuilder

    def build
      doc_path = generate_doc
      temp_pdf_path = convert_to_pdf(doc_path)
      File.delete(doc_path)
      return temp_pdf_path
    end

  end
end