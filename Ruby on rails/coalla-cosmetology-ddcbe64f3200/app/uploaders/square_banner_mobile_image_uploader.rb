class SquareBannerMobileImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 240, 420
  end
end