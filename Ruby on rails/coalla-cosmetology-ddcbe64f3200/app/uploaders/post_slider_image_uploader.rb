class PostSliderImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :slider do
    resize_to_fill(1907, 490)
  end

  version :preview do
    resize_to_fill(763, 196)
  end
end