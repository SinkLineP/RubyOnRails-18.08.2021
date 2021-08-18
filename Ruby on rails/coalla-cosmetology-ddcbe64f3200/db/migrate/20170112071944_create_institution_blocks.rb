class CreateInstitutionBlocks < ActiveRecord::Migration
  def change
    create_table :institution_blocks do |t|
      t.text :code
      t.text :video_url
      t.text :content
      t.text :link
      t.text :link_title
      t.timestamps
    end
  end
end
