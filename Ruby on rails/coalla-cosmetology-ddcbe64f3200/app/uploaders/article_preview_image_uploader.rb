class ArticlePreviewImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 417, 417
  end
end