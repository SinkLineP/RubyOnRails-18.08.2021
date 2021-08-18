module Documents
  module DocBuilder

    protected

    def build_doc(template_name, data)
      template_path = "#{Rails.root}/lib/documents/templates/#{template_name}.odt"

      doc = ODFReport::Report.new(template_path) do |r|
        data.each do |field, value|
          if value.respond_to?(:call)
            value.call(r)
          else
            r.add_field(field, value)
          end
        end
      end

      result = tmp_path
      doc.generate(result)
      File.chmod(0777, result)
      result
    end

    def tmp_path
      "#{Rails.root}/tmp/#{SecureRandom.hex}.odt"
    end
  end
end
