class HistoryEventImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 392, 241
  end
end