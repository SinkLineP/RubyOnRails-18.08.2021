class MetaTagsImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 200, 200
  end
end