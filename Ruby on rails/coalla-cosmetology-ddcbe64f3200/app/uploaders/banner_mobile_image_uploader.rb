class BannerMobileImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 600, 900
  end
end