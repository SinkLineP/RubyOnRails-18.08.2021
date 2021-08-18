# == Schema Information
#
# Table name: course_links
#
#  id         :integer          not null, primary key
#  link       :text
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_course_links_on_course_id  (course_id)
#

class CourseLink < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_links
end
