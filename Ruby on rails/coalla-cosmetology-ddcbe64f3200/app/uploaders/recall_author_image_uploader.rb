class RecallAuthorImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    process resize_to_limit: [260, 260]
  end
end
