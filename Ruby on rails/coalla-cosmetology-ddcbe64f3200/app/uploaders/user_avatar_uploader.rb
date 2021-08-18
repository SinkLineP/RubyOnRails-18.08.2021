class UserAvatarUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 110, 110
  end

  version :middle do
    resize_to_fill 240, 240
  end

  version :thumb do
    resize_to_fill 50, 50
  end
end