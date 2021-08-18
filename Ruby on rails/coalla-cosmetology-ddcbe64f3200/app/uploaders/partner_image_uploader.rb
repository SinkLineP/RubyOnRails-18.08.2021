class PartnerImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 130, 40
  end
end
