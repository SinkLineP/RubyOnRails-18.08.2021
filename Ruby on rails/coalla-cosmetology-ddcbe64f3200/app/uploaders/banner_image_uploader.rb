class BannerImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 1440, 100
  end
end