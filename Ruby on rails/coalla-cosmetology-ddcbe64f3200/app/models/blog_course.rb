# == Schema Information
#
# Table name: blog_courses
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  article_id :integer
#  created_at :datetime
#  updated_at :datetime
#  position   :integer          default(0), not null
#
# Indexes
#
#  index_blog_courses_on_article_id  (article_id)
#  index_blog_courses_on_course_id   (course_id)
#

class BlogCourse < ActiveRecord::Base

  belongs_to :course, inverse_of: :blog_courses
  belongs_to :article, inverse_of: :blog_courses

  scope :ordered, -> { order(:position) }

end
