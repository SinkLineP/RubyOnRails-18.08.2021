class PdfImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    process resize_to_limit: [2048, 2048]
    process optimize: [{ quality: 60 }]
  end
end