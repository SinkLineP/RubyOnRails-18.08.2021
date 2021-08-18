class SquareBannerImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 630, 630
  end
end