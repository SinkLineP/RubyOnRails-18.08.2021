class AboutImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :tour do
    resize_to_fill 417, 417
  end

  version :reward do
    resize_to_fit 1_000_000, 370
  end
end