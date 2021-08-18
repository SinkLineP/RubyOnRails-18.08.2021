class EducationPicturesRecreate < ActiveRecord::Migration
  def up
    EducationDocumentPicture.find_each{|document_picture| document_picture.image.recreate_versions! if document_picture.image? }
  end

  def down
  end
end
