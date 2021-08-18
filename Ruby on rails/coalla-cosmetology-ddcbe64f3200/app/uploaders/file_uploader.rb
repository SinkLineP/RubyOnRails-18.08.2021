class FileUploader < CarrierWave::Uploader::Base
  storage :file
  def store_dir
    "uploads/document/#{mounted_as}/#{model.id}"
  end
end