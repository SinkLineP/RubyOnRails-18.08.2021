module Documents
  class DocumentBuilder
    def self.build(document_name, options={})
      DocumentBuilder.new(document_name, options).build
    end

    def initialize(document_name, options={})
      @klass = "Documents::Generators::#{document_name}".constantize
      @options = options
    end

    def build
      doc_path = generate_doc
      temp_pdf_path = convert_to_pdf(doc_path)
      File.delete(doc_path)
      move_pdf(temp_pdf_path)
    end

    def convert_to_pdf(doc_path, pdf_name = nil)
      pdf_name ||= build_pdf_name
      temp_path = "#{Rails.root}/tmp/#{pdf_name}"
      Libreconv.convert(doc_path, temp_path, libreoffice_command)
      temp_path
    end

    private

    def generate_doc
      document = @klass.new(@options)
      document.generate
    end

    def move_pdf(temp_pdf_path)
      pdf_path = "documents/#{klass_name}/#{Date.today.to_s}/#{File.basename(temp_pdf_path)}"
      move_with_path(temp_pdf_path, "#{Rails.root}/#{pdf_path}")
      pdf_path
    end

    def move_with_path(src, dst)
      FileUtils.mkdir_p(File.dirname(dst))
      FileUtils.mv(src, dst)
    end

    def klass_name
      @klass.name.demodulize.underscore
    end

    def build_pdf_name
      russian_prefix = I18n.t("documents.#{klass_name}")
      prefix = I18n.transliterate(russian_prefix)
      "#{prefix} #{Time.now.strftime('%Y%m%d%H%M%S%9N')}.pdf".gsub("\s", '_')
    end

    def mac_os?
      (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def libreoffice_command
      if mac_os?
        '/Applications/LibreOffice.app/Contents/MacOS/soffice'
      else
        nil
      end
    end
  end
end