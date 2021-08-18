class ArticleMainImageUploader < GenericImageUploader
  include ImageUploaderUtils

  version :main do
    resize_to_fill 1310, 740
  end
end