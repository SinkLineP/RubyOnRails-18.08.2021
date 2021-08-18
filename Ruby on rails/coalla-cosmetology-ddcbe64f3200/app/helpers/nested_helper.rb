module NestedHelper
  def fields(f, association)
    new_object = f.object.send(association).klass.new
    fields = f.fields_for(association, new_object, child_index: '__id__') do |builder|
      render "admin/#{f.object.class.name.pluralize.underscore}/#{association.to_s.singularize}_fields", f: builder
    end

    fields.gsub("\n", '')
  end
end