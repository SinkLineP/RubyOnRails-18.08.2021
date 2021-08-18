class PrivateFileUploader < CarrierWave::Uploader::Base
  storage :file

  def self.root
    Rails.root.to_s
  end

  def root
    Rails.root.to_s
  end

  def store_dir
    "private/uploads/#{model.class.name.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    'private/uploads/tmp'
  end
end