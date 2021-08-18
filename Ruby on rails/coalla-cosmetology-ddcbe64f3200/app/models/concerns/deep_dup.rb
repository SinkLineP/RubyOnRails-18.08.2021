module DeepDup
  def deep_dup(options = {})
    associations = options.fetch(:associations, [])
    files = options.fetch(:files, [])

    result = dup()

    associations.each do |association|
      if association.is_a?(Hash)
        association_name = association.keys.first
        key_name = "#{association.values.first}="
      else
        association_name = association
        key_name = "#{self.class.table_name.singularize.underscore}_id="
      end
      if send(association_name).respond_to?(:<<)
        send(association_name).each do |association_item|
          association_item.send(key_name, nil)
          duplication_method = association_item.respond_to?(:deep_dup) ? :deep_dup : :dup
          result.send(association_name) << association_item.send(duplication_method)
        end
      else
        loaded_association = send(association_name)
        if loaded_association
          loaded_association.send(key_name, nil)
          duplication_method = loaded_association.respond_to?(:deep_dup) ? :deep_dup : :dup
          result.send("#{association_name}=", loaded_association.send(duplication_method))
        end
      end
    end

    files.each do |file|
      result.send("#{file}=", File.open(send(file).path)) if send(file).present?
    end

    result
  end
end