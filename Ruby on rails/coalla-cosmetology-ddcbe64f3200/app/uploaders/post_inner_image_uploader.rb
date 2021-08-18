class PostInnerImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :promo do
    resize_to_fit(1024, 1_000_000)
  end
end