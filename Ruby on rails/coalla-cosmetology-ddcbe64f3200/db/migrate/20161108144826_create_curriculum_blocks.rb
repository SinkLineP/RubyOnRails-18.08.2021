class CreateCurriculumBlocks < ActiveRecord::Migration
  def change
    create_table :curriculum_blocks do |t|
      t.text :title
      t.text :content

      t.timestamps null: false
    end
  end
end
