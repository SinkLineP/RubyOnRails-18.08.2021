class PostAnnouncementImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :preview do
    resize_to_fill(328, 217)
  end

  version :promo do
    resize_to_fill(1024, 234)
  end
end