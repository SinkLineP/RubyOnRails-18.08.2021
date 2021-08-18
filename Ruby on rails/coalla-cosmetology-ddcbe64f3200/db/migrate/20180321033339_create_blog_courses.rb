class CreateBlogCourses < ActiveRecord::Migration
  def change
    create_table :blog_courses do |t|
      t.references :course, index: true, foreign_key: true
      t.references :article, index: true, foreign_key: true
      t.timestamps
    end
  end
end
