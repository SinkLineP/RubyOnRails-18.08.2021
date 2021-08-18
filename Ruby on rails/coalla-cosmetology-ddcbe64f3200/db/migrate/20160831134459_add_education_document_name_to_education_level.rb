class AddEducationDocumentNameToEducationLevel < ActiveRecord::Migration
  def change
    add_column :education_levels, :education_document_name, :text
  end
end
