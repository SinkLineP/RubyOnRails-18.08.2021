class QuestionImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 300, 300
  end
end