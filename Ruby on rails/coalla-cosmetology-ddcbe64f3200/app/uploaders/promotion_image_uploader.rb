class PromotionImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 350, 220
  end
end