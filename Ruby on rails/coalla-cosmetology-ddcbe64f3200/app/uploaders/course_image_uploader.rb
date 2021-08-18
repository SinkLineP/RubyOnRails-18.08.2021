class CourseImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :promo do
    resize_to_limit 1920, 1_000_000
  end

  version :thumb do
    resize_to_limit 370, 1_000_000
  end
end