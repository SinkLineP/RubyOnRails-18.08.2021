class RecallFileUploader < GenericImageUploader
  include ImageUploaderUtils

  version :popup do
    process resize_to_limit: [1920, 1080]
  end

  version :main do
    process resize_to_fit: [600, 450]
  end

  version :thumb do
    process resize_to_fit: [200, 150]
  end
end
