class AddDefaultCourseToCourses < ActiveRecord::Migration
  def up
    add_column :courses, :default_course, :boolean, null: false, default: false
    Course.where(slug: %w(mladshaya-meditsinskaya-sestra-brat detskie-strizhki)).update_all(default_course: true)
  end

  def down
    remove_column :courses, :default_course
  end
end
