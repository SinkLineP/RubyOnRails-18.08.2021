class PdfUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/document/#{mounted_as}/#{model.class.to_s.underscore}/#{model.id}"
  end

  def extension_white_list
    %w(pdf)
  end
end