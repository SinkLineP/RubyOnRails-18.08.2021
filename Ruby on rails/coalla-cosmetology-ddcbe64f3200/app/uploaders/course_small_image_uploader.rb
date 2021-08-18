class CourseSmallImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :thumb do
    resize_to_fill 750, 750
  end
end