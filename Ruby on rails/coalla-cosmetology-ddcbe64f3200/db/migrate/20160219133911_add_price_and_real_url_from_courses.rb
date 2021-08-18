class AddPriceAndRealUrlFromCourses < ActiveRecord::Migration
  def up
    add_column :courses, :price, :integer
    add_column :courses, :external_url, :text

    courses = YAML::load_file( Rails.root.join('db', 'fixtures', 'courses.yml') )
    courses.each do |course|
      _course = Course.find_by(id: course['id'])
      _course.update!(price: course['price'], external_url: course['external_url']) if _course
    end
  end

  def down
    remove_columns :courses, :price, :external_url
  end
end
