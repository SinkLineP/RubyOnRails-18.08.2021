class InstitutionImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 500, 370
  end
end