class MaterialPreviewUploader < GenericImageUploader
  include ImageUploaderUtils

  def store_dir
    "uploads/material/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    resize_to_fill(50, 68)
  end

  version :main do
    resize_to_fill(180, 250)
  end
end