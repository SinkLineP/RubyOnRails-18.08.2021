class ColumnVariantImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 100, 100
  end

end