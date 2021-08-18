module StringArrayInput
  def array_input_field(field_name, options = {})
    define_method "#{field_name}_string" do
      send(field_name).join(',')
    end

    define_method "#{field_name}_string=" do |value|
      return if value.blank?
      value = value.gsub(/\s+/, '') if options.fetch(:strip, true)
      send("#{field_name}=", value.split(',').uniq.reject(&:empty?))
    end
  end
end