module SimpleIdsList
  def simple_ids_list(association_name, options = {})
    association_name = association_name.to_s
    through_association_name = options[:through_association_name] || "#{self.name.underscore}_#{association_name}"
    item_name = association_name.singularize
    item_id_field = "#{item_name}_id".to_sym
    model = options[:model] || association_name.classify.constantize

    define_method "#{association_name}_ids=" do |value|
      new_items = (value.presence || []).map { |id| model.find_by(id: id) }.compact
      send(through_association_name).each do |old_item|
        next if new_items.map(&:id).include?(old_item.send(item_id_field))
        old_item.mark_for_destruction
      end
      new_items_attributes = new_items.map.with_index do |item, index|
        old_item = send(through_association_name).find_by(item_id_field => item.id)
        attributes = old_item ? old_item.as_json(only: [:id, item_id_field]) : { item_id_field => item.id }
        attributes[:position] = index
        attributes.compact
      end
      self.send("#{through_association_name}_attributes=", new_items_attributes)
    end
  end
end