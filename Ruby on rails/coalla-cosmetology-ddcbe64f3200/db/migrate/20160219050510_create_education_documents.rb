class CreateEducationDocuments < ActiveRecord::Migration
  def change
    create_table :education_documents do |t|
      t.text :title, null: false
      t.text :description

      t.timestamps null: false
    end
  end
end
