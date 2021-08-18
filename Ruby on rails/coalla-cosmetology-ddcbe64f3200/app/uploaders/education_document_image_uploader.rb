class EducationDocumentImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 109, 80
  end

  version :slider_item do
    resize_to_fit 500, 367
  end

  version :library do
    resize_to_limit 2048, 1_000_000
  end
end