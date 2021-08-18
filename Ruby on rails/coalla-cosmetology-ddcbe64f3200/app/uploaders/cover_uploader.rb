class CoverUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 400, 200
  end

  version :library do
    resize_to_fill 100, 145
  end
end