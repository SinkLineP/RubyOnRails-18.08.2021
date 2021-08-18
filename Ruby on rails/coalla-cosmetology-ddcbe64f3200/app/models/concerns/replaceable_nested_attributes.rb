module ReplaceableNestedAttributes
  def replaceable_nested_attributes(association_name)
    define_method "#{association_name}_attributes=" do |items_attributes|
      attributes = items_attributes || []
      attributes = attributes.map { |_key, attrs| attrs } if attributes.is_a?(Hash)
      attributes = attributes.map(&:with_indifferent_access)

      send(association_name).each do |item|
        next if item.persisted? && attributes.any? { |attrs| attrs[:id].to_i == item.id && !call_reject_if(association_name, attrs) }
        item.mark_for_destruction
      end

      super(items_attributes)
    end
  end
end