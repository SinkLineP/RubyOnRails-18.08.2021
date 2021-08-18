class GraduateAvatarUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 120, 120
  end
end