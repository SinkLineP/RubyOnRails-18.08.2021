class RecallVideoImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :thumb do
    resize_to_fill 415, 235
  end
end