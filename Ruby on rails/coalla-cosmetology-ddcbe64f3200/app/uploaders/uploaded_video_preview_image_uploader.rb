class UploadedVideoPreviewImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 1280, 720
  end

  version :recall do
    resize_to_fill 415, 235
  end
end